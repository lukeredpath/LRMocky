//
//  LRConsecutiveCallAction.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRConsecutiveCallAction.h"


@implementation LRConsecutiveCallAction {
  NSMutableArray *_actions;
  NSUInteger _invocationCount;
}

- (id)init
{
  if (self = [super init]) {
    _actions = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)addAction:(id<LRExpectationAction>)action
{
  [_actions addObject:action];
}

- (void)invoke:(NSInvocation *)invocation
{
  [[self nextAction] invoke:invocation];
  _invocationCount++;
}

- (id<LRExpectationAction>)nextAction
{
  if (_invocationCount >= _actions.count) {
    return [_actions lastObject];
  }
  return _actions[_invocationCount];
}

@end
