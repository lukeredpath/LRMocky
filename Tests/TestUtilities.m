//
//  TestUtilities.m
//  Mocky
//
//  Created by Luke Redpath on 03/01/2013.
//
//

#import "TestUtilities.h"

NSInvocation *anyValidInvocation(void) {
  NSMethodSignature *validMethodSignature = [NSObject instanceMethodSignatureForSelector:@selector(init)];
  return [NSInvocation invocationWithMethodSignature:validMethodSignature];
}

@implementation CapturesInvocations {
  NSMutableArray *_capturedInvocations;
  CapturesInvocationsOnInvocationHandler _invocationHandler;
}

@synthesize capturedInvocations = _capturedInvocations;

- (id)init
{
  self = [super init];
  if (self) {
    _capturedInvocations = [[NSMutableArray alloc] init];
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
    [_capturedInvocations addObject:invocation];
    
    if (_invocationHandler) {
      _invocationHandler(invocation);
    }
  }
}

- (NSInvocation *)lastInvocation
{
  return [_capturedInvocations lastObject];
}

- (void)onInvocation:(CapturesInvocationsOnInvocationHandler)invocationHandler
{
  _invocationHandler = [invocationHandler copy];
}

@end
