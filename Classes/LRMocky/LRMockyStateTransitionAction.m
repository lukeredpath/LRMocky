//
//  LRMockyStateTransitionAction.m
//  Mocky
//
//  Created by Luke Redpath on 30/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRMockyStateTransitionAction.h"
#import "LRMockyState.h"

@implementation LRMockyStateTransitionAction

+ (id)transitionToState:(LRMockyState *)state;
{
  return [[self alloc] initWithState:state];
}

- (id)initWithState:(LRMockyState *)aState;
{
  if (self = [super init]) {
    state = aState;
  }
  return self;
}


- (void)invoke:(NSInvocation *)invocation
{
  [state activate];
}

@end
