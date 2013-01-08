//
//  LRExpectationActions.m
//  Mocky
//
//  Created by Luke Redpath on 06/01/2013.
//
//

#import "LRExpectationActions.h"
#import "LRPerformBlockAction.h"
#import "LRConsecutiveCallAction.h"
#import "LRCompositeAction.h"
#import "LRMockyStateMachine.h"
#import "NSInvocation+Conveniences.h"

@implementation LRExpectationActions {
  __weak id<LRExpectationActionCollector> _collector;
}

- (id)initWithActionCollector:(id<LRExpectationActionCollector>)collector
{
  if ((self = [super init])) {
    _collector = collector;
  }
  return self;
}

- (void)returns:(id)returnValue
{
  [self performsBlock:^(NSInvocation *invocation) {
    [invocation setReturnValueFromObject:returnValue];
  }];
}

- (void)returnsValue:(void *)value
{
  [self performsBlock:^(NSInvocation *invocation) {
    [invocation setReturnValue:(void *)&value];
  }];
}

- (void)performsBlock:(void (^)(NSInvocation *))block
{
  [_collector addAction:[[LRPerformBlockAction alloc] initWithBlock:block]];
}

- (void)raisesException:(NSException *)exception
{
  [self performsBlock:^(NSInvocation *unused) {
    [exception raise];
  }];
}

- (void)doesAllOf:(void (^)(id<LRExpectationActionSyntax>))actionsBlock
{
  [self composeAction:[[LRCompositeAction alloc] init] withActions:actionsBlock];
}

- (void)onConsecutiveCalls:(void (^)(id<LRExpectationActionSyntax>))actionsBlock
{
  [self composeAction:[[LRConsecutiveCallAction alloc] init] withActions:actionsBlock];
}

- (void)state:(LRMockyStateMachine *)state becomes:(NSString *)newState
{
  [self performsBlock:^(NSInvocation *unused) {
    [state transitionTo:newState];
  }];
}

#pragma mark Private

- (void)composeAction:(id<LRExpectationAction,LRExpectationActionCollector>)action withActions:(void (^)(id<LRExpectationActionSyntax>))actionsBlock
{
  LRExpectationActions *actions = [[LRExpectationActions alloc] initWithActionCollector:action];
  actionsBlock(actions);
  [_collector addAction:action];
}

@end
