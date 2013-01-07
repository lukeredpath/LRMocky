//
//  LRMockyObject.m
//  Mocky
//
//  Created by Luke Redpath on 03/01/2013.
//
//

#import "LRMockObject.h"
#import "LRReflectionImposterizer.h"

@implementation LRMockObject {
  id<LRInvocationDispatcher> _dispatcher;
  id<LRImposterizer> _imposterizer;
  id _mockedType;
  NSString *_name;
}

- (id)initWithInvocationDispatcher:(id<LRInvocationDispatcher>)dispatcher
                        mockedType:(id)mockedType
                              name:(NSString *)name
{
  NSParameterAssert(dispatcher);
  
  if ((self = [super init])) {
    _dispatcher = dispatcher;
    _mockedType = mockedType;
    _name = [name copy];
    _imposterizer = [[LRReflectionImposterizer alloc] init];
  }
  return self;
}

- (void)invoke:(NSInvocation *)invocation
{
  if ([self respondsToSelector:invocation.selector]) {
    [invocation invokeWithTarget:self];
  }
  else {
    [_dispatcher dispatch:invocation];
  }
}

- (NSString *)description
{
  return _name;
}

- (id)imposterizeTo:(id<LRInvokable>)invokable ancilliaryProtocols:(NSArray *)ancilliaryProtocols
{
  return [_imposterizer imposterize:_mockedType invokable:invokable ancilliaryProtocols:ancilliaryProtocols];
}

- (id)imposterize
{
  return [self imposterizeTo:self ancilliaryProtocols:@[@protocol(LRImposterizable)]];
}

@end
