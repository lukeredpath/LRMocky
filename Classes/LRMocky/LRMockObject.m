//
//  LRMockyObject.m
//  Mocky
//
//  Created by Luke Redpath on 03/01/2013.
//
//

#import "LRMockObject.h"
#import "LRReflectionImposterizer.h"
#import "LRInvocationToExpectationTranslator.h"

@implementation LRMockObject {
  id<LRInvocationDispatcher> _dispatcher;
  id<LRImposterizer> _imposterizer;
  id _mockedType;
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
    [invocation setTarget:self];
    [invocation invoke];
  }
  else {
    [_dispatcher dispatch:invocation];
  }
}

- (id)captureExpectationTo:(id<LRExpectationCapture>)capture
{
  LRInvocationToExpectationTranslator *translator = [[LRInvocationToExpectationTranslator alloc] initWithExpectationCapture:capture];
  
  id imposter = [_imposterizer imposterize:_mockedType invokable:translator ancilliaryProtocols:@[@protocol(LRExpectationCaptureSyntaticSugar)]];
  NSAssert(imposter, @"Imposter should never be nil.");
  
  return imposter;
}

@end
