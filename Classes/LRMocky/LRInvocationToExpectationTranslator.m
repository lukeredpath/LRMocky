//
//  LRInvocationToExpectationTranslator.m
//  Mocky
//
//  Created by Luke Redpath on 03/01/2013.
//
//

#import "LRInvocationToExpectationTranslator.h"

@implementation LRInvocationToExpectationTranslator {
  id<LRExpectationCapture> _capture;
}

- (id)initWithExpectationCapture:(id<LRExpectationCapture>)capture
{
  if ((self = [super init])) {
    _capture = capture;
  }
  return self;
}

- (void)invoke:(NSInvocation *)invocation
{
  if ([_capture respondsToSelector:invocation.selector]) {
    [invocation setTarget:_capture];
    [invocation invoke];
  }
  else {
    [_capture createExpectationFromInvocation:invocation];
  }
}

@end

