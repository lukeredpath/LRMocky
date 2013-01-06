//
//  LRConsecutiveCallAction.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRConsecutiveCallAction.h"


@implementation LRConsecutiveCallAction {
  NSMutableArray *actions;
  NSUInteger numberOfCalls;
}

- (id)initWithActions:(NSArray *)actionList;
{
  if (self = [super init]) {
    actions = [actionList copy];
    numberOfCalls = 0;  
  }
  return self;
}


- (void)invoke:(NSInvocation *)invocation
{
  [(id<LRExpectationAction>)actions[numberOfCalls] invoke:invocation];
  
  numberOfCalls++;
  if (numberOfCalls == [actions count]) {
    numberOfCalls = [actions count] - 1;
  }
}

@end
