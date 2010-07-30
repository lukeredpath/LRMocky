//
//  LRMockyStates.m
//  Mocky
//
//  Created by Luke Redpath on 30/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRMockyStates.h"


@implementation LRMockyStates

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

@implementation LRMockyState

+ (id)stateWithLabel:(NSString *)label inContext:(LRMockyStates *)context;
{
  return [[[self alloc] initWithLabel:label context:context] autorelease];
}

- (id)initWithLabel:(NSString *)aLabel context:(LRMockyStates *)aContext;
{
  if (self = [super init]) {
    label = [aLabel copy];
    context = [aContext retain];
  }
  return self;
}

- (BOOL)isEqual:(id)object;
{
  return ([object isKindOfClass:[LRMockyState class]] && [self isEqualToState:object]);
}

- (BOOL)isEqualToState:(LRMockyState *)state;
{
  return [state matches:label];
}

- (BOOL)matches:(NSString *)stateLabel
{
  return [stateLabel isEqual:label];
}

- (NSString *)state;
{
  return [NSString stringWithFormat:@"<LRMockyState %@>", label];
}

- (void)dealloc;
{
  [label release];
  [context release];
  [super dealloc];
}

- (BOOL)isCurrentState;
{
  return [context isCurrentState:self]; 
}

- (void)transitionToState;
{
  [context transitionToState:self];
}

@end

@implementation LRMockyStateTransitionAction

+ (id)transitionToState:(LRMockyState *)state;
{
  return [[[self alloc] initWithState:state] autorelease];
}

- (id)initWithState:(LRMockyState *)aState;
{
  if (self = [super init]) {
    state = [aState retain];
  }
  return self;
}

- (void)dealloc
{
  [state release];
  [super dealloc];
}

- (void)invoke:(NSInvocation *)invocation
{
  [state transitionToState];
}

@end

