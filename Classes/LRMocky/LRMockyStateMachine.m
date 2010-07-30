//
//  LRMockyStateMachine.m
//  Mocky
//
//  Created by Luke Redpath on 30/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRMockyStateMachine.h"
#import "LRMockyState.h"

@implementation LRMockyStateMachine

- (id)initWithName:(NSString *)aName;
{
  return [self initWithName:aName defaultState:nil];
}

- (id)initWithName:(NSString *)aName defaultState:(NSString *)label;
{
  if (self = [super init]) {
    name = [aName copy];
    
    if (label) {
      currentState = [self state:label];
    }
  }
  return self;
}

- (void)dealloc 
{
  [name release];
  [currentState release];
  [super dealloc];
}

- (LRMockyState *)state:(NSString *)label;
{
  return [LRMockyState stateWithLabel:label inContext:self];
}

- (LRMockyState *)becomes:(NSString *)label;
{
  return [self state:label];
}

- (LRMockyState *)hasBecome:(NSString *)label;
{
  return [self state:label];
}

- (void)transitionToState:(LRMockyState *)newState;
{
  [currentState release];
  currentState = [newState retain];
}

- (BOOL)isCurrentState:(LRMockyState *)state;
{
  return [state isEqual:currentState]; 
}

@end
