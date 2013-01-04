//
//  LRUnexpectedInvocationException.m
//  Mocky
//
//  Created by Luke Redpath on 03/01/2013.
//
//

#import "LRUnexpectedInvocationException.h"
#import "LRExpectation.h"
#import "NSInvocation+OCMAdditions.h"

NSString *const LRUnexpectedInvocationInvocationUserInfoKey = @"invocation";

@implementation LRUnexpectedInvocationException {
  NSInvocation *_invocation;
}

+ (id)exceptionWithInvocation:(NSInvocation *)invocation
{
  return [[self alloc] initWithInvocation:invocation];
}

- (id)initWithInvocation:(NSInvocation *)invocation
{
  if ((self = [super initWithName:LRMockyExpectationError reason:[self reason] userInfo:@{}])) {
    _invocation = invocation;
    
    if (![_invocation argumentsRetained]) {
      [_invocation retainArguments];
    }
  }
  return self;
}

- (NSDictionary *)userInfo
{
  return @{LRUnexpectedInvocationInvocationUserInfoKey : _invocation};
}

- (NSString *)reason
{
  return @"failure!";
  
  NSMutableArray *arguments = [NSMutableArray array];
  for (int i = 2; i < [[_invocation methodSignature] numberOfArguments]; i++) {
    [arguments addObject:[_invocation getArgumentAtIndexAsObject:i]];
  }
  return [NSString stringWithFormat:@"Unexpected method %@ called on %@ with arguments: %@",
                NSStringFromSelector([_invocation selector]), [_invocation target], arguments];
}

@end
