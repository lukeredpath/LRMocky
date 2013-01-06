//
//  LRExpectationActions.m
//  Mocky
//
//  Created by Luke Redpath on 06/01/2013.
//
//

#import "LRExpectationActions.h"
#import "LRReturnValueAction.h"
#import "LRPerformBlockAction.h"
#import "LRConsecutiveCallAction.h"

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
  [_collector addAction:[[LRReturnValueAction alloc] initWithReturnValue:returnValue]];
}

- (void)performBlock:(void (^)(NSInvocation *))block
{
  [_collector addAction:[[LRPerformBlockAction alloc] initWithBlock:block]];
}

- (void)onConsecutiveCalls:(void (^)(id<LRExpectationActionSyntax>))actionsBlock
{
  LRConsecutiveCallAction *consecutiveCalls = [[LRConsecutiveCallAction alloc] init];
  LRExpectationActions *actions = [[LRExpectationActions alloc] initWithActionCollector:consecutiveCalls];
  actionsBlock(actions);
  [_collector addAction:consecutiveCalls];
}

@end
