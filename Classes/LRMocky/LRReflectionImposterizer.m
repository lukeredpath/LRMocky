//
//  LRImposterizer.m
//  Mocky
//
//  Created by Luke Redpath on 03/01/2013.
//
//

#import "LRReflectionImposterizer.h"
#import <objc/runtime.h>

typedef NSMethodSignature* (^LRMethodSignatureProvider)(SEL selector);

@protocol LRImposterizedType <NSObject>
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector;
- (BOOL)respondsToSelector:(SEL)aSelector;
@end

@interface LRImposterizedClass : NSObject <LRImposterizedType>
+ (id)imposterize:(Class)aClass;
@end

@interface LRImposterizedProtocol : NSObject <LRImposterizedType>
+ (id)imposterize:(Protocol *)aProtocol;
@end

@interface LRMultipleImposterizedTypes : NSObject <LRImposterizedType>
+ (id)withTypes:(NSArray *)types;
@end

#pragma mark -

@interface LRImposter : NSProxy

- (id)initWithInvokable:(id<LRInvokable>)invokable type:(id<LRImposterizedType>)type;

@end

@implementation LRImposter {
  id<LRImposterizedType> _type;
  id<LRInvokable> _invokable;
}

- (id)initWithInvokable:(id<LRInvokable>)invokable type:(id<LRImposterizedType>)type
{
  NSParameterAssert(type);
  NSParameterAssert(invokable);
  
  _type = type;
  _invokable = invokable;
  
  return self;
}

- (NSString *)debugDescription
{
  return [NSString stringWithFormat:@"<Imposter: %@>", [_type description]];
}

- (NSString *)description
{
  return [_invokable description];
}

#pragma mark - Message forwarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
  return [_type methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
  [_invokable invoke:invocation];
}

#pragma mark - Type conformance

- (BOOL)respondsToSelector:(SEL)aSelector
{
  return [_type respondsToSelector:aSelector];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
  return [_type conformsToProtocol:aProtocol];
}

@end

#pragma mark -

@implementation LRReflectionImposterizer

- (id)imposterizeClass:(Class)class invokable:(id<LRInvokable>)invokable ancilliaryProtocols:(NSArray *)ancilliaryProtocols
{
  NSMutableArray *types = [NSMutableArray arrayWithObject:[LRImposterizedClass imposterize:class]];
  
  for (Protocol *protocol in ancilliaryProtocols) {
    [types addObject:[LRImposterizedProtocol imposterize:protocol]];
  }
  
  return [[LRImposter alloc] initWithInvokable:invokable
                                          type:[LRMultipleImposterizedTypes withTypes:types]];
}

- (id)imposterizeProtocol:(Protocol *)protocol invokable:(id<LRInvokable>)invokable ancilliaryProtocols:(NSArray *)ancilliaryProtocols
{
  NSMutableArray *types = [NSMutableArray arrayWithObject:[LRImposterizedProtocol imposterize:protocol]];
  
  for (Protocol *protocol in ancilliaryProtocols) {
    [types addObject:[LRImposterizedProtocol imposterize:protocol]];
  }
  
  return [[LRImposter alloc] initWithInvokable:invokable
                                          type:[LRMultipleImposterizedTypes withTypes:types]];
}

@end

#pragma mark - Imposterized types

@implementation LRImposterizedClass {
  Class _class;
}

- (id)initWithClass:(Class)aClass
{
  if ((self = [super init])) {
    _class = aClass;
  }
  return self;
}

+ (id)imposterize:(Class)aClass
{
  return [[self alloc] initWithClass:aClass];
}

- (NSString *)description
{
  return NSStringFromClass(_class);
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
  return [_class instanceMethodSignatureForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
  return [_class instancesRespondToSelector:aSelector];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
  if (aProtocol == @protocol(LRImposterizedType)) {
    return YES;
  }
  return [_class conformsToProtocol:aProtocol];
}

@end

@implementation LRImposterizedProtocol {
  Protocol *_protocol;
}

- (id)initWithProtocol:(Protocol *)protocol;
{
  if ((self = [super init])) {
    _protocol = protocol;
  }
  return self;
}

+ (id)imposterize:(Protocol *)aProtocol
{
  return [[self alloc] initWithProtocol:aProtocol];
}

- (NSString *)description
{
  return NSStringFromProtocol(_protocol);
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
  struct objc_method_description methodDescription = [self methodDescriptionForSelector:aSelector];
  
  if (methodDescription.name == NULL && methodDescription.types == NULL) {
    return nil;
  }
  
  return [NSMethodSignature signatureWithObjCTypes:methodDescription.types];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
  struct objc_method_description methodDescription = [self methodDescriptionForSelector:aSelector];
  
  if (methodDescription.name == NULL && methodDescription.types == NULL) {
    return NO;
  }
  return YES;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
  if (aProtocol == @protocol(LRImposterizedType)) {
    return YES;
  }
  if (aProtocol == _protocol) {
    return YES;
  }
  
  unsigned int protocolCount = 0;
  
  Protocol *__unsafe_unretained *protocols = protocol_copyProtocolList(_protocol, &protocolCount);
  
  if (protocols == NULL) {
    return NO;
  }
  
  for (int i = 0; i < protocolCount; i++) {
    Protocol *thisProtocol = protocols[i];
    
    if (thisProtocol == aProtocol) {
      return YES;
    }
  }
  return NO;
}

- (struct objc_method_description)methodDescriptionForSelector:(SEL)aSelector
{
  struct objc_method_description description;
  
  for (SInt8 mask = 0; mask < 2; mask++) {
    description = protocol_getMethodDescription(_protocol, aSelector, YES, YES);
    
    if (description.name == NULL && description.types == NULL) {
      description = protocol_getMethodDescription(_protocol, aSelector, NO, YES);
    }
    if (description.name == NULL && description.types == NULL) continue;
  }
  return description;
}

@end

@implementation LRMultipleImposterizedTypes {
  NSArray *_types;
}

+ (id)withTypes:(NSArray *)types
{
  return [[self alloc] initWithTypes:types];
}

- (id)initWithTypes:(NSArray *)types
{
  for (id type in types) {
    NSParameterAssert([type conformsToProtocol:@protocol(LRImposterizedType)]);
  }
  
  if ((self = [super init])) {
    _types = types;
  }
  return self;
}

- (NSString *)debugDescription
{
  NSMutableString *descriptions = [NSMutableString string];
  for (id type in _types) {
    [descriptions appendFormat:@"%@,", [type debugDescription]];
  }
  return [NSString stringWithFormat:@"<Multiple imposterized types: %@>", descriptions];
}

- (NSString *)description
{
  /* We assume the first type is the main type, and the rest are ancilliary types */
  return [[_types objectAtIndex:0] description];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
  for (id<LRImposterizedType> type in _types) {
    NSMethodSignature *methodSignature = [type methodSignatureForSelector:aSelector];
    
    if (methodSignature) {
      return methodSignature;
    }
  }
  return nil;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
  for (id<LRImposterizedType> type in _types) {
    if ([type respondsToSelector:aSelector]) {
      return YES;
    }
  }
  
  return NO;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
  if (aProtocol == @protocol(LRImposterizedType)) {
    return YES;
  }
  for (id<LRImposterizedType> type in _types) {
    if ([type conformsToProtocol:aProtocol]) {
      return YES;
    }
  }
  
  return NO;
}

@end
