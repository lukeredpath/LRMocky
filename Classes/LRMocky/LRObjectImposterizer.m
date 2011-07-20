//
//  LRObjectImposterizer.m
//  Mocky
//
//  Created by Luke Redpath on 24/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRObjectImposterizer.h"
#import <objc/runtime.h>

#define kOBJECT_IMPOSTERIZER_ASSOCIATION_KEY "_mockyCurrentImposterizer"

@implementation LRObjectImposterizer

- (id)initWithObject:(id)object;
{
  if (self = [super init]) {
    objectToImposterize = [object retain];
  }
  return self;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
  if ([self.delegate shouldActAsImposterForInvocation:anInvocation]) {
    [self.delegate handleImposterizedInvocation:anInvocation];
  }
  else {
    [anInvocation invokeWithTarget:objectToImposterize];
  }
}

- (void)dealloc
{
  [objectToImposterize release];
  [super dealloc];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
  return [objectToImposterize methodSignatureForSelector:sel];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
  return [objectToImposterize respondsToSelector:aSelector];
}

- (LRImposterizer *)matchingImposterizer;
{
  return [[[LRObjectImposterizer alloc] initWithObject:objectToImposterize] autorelease];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"forObject:%@", objectToImposterize];
}

/* swap the class of the imposterized object to a dynamic subclass that forwards stubbed invocations
    back to the imposterizer. This technique is borrowed entirely from OCMock */

- (void)setupInvocationHandlerForImposterizedObjectForInvocation:(NSInvocation *)invocation
{  
  // create a subclass of the imposterized object
  
  Class realClass = [objectToImposterize class];
	double timestamp = [NSDate timeIntervalSinceReferenceDate];
	const char *className = [[NSString stringWithFormat:@"%@-Imposterizer-%p-%f", realClass, objectToImposterize, timestamp] cString]; 
	Class subclass = objc_allocateClassPair(realClass, className, 0);
	objc_registerClassPair(subclass);
	object_setClass(objectToImposterize, subclass);
  
  // configure it's forwardInvocation: method to delegate to the imposterizer
  
	Method forwardInvocationMethod = class_getInstanceMethod([self class], @selector(forwardInvocationForRealObject:));
	IMP forwardInvocationImp = method_getImplementation(forwardInvocationMethod);
	const char *forwardInvocationTypes = method_getTypeEncoding(forwardInvocationMethod);
	class_addMethod(subclass, @selector(forwardInvocation:), forwardInvocationImp, forwardInvocationTypes);
  
  // ensure that calls to the stubbed selector are handled by forwardInvocation:
  
  Class dynamicSubclass = [objectToImposterize class]; 
	Method originalMethod = class_getInstanceMethod(dynamicSubclass, invocation.selector);
	IMP forwarderImp = [subclass instanceMethodForSelector:@selector(__MOCKY_SELECTOR_THAT_WILL_NOT_EXIST)];
	class_addMethod(dynamicSubclass, method_getName(originalMethod), forwarderImp, method_getTypeEncoding(originalMethod)); 
  
  // finally, we need a way to get the imposterizer from the imposterized object
  objc_setAssociatedObject(objectToImposterize, kOBJECT_IMPOSTERIZER_ASSOCIATION_KEY, self, OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation LRObjectImposterizer (RealObjectHandler)

- (void)forwardInvocationForRealObject:(NSInvocation *)anInvocation
{
  // self is the imposterized object, not the imposterizer
  LRObjectImposterizer *imposterizer = objc_getAssociatedObject(self, kOBJECT_IMPOSTERIZER_ASSOCIATION_KEY);
  
  if (imposterizer) {
    [imposterizer forwardInvocation:anInvocation];
  }
}

@end
