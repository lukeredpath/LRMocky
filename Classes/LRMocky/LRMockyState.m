//
//  LRMockyState.m
//  Mocky
//
//  Created by Luke Redpath on 30/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRMockyState.h"
#import "LRMockyStateMachine.h"

@implementation LRMockyState

+ (id)stateWithLabel:(NSString *)label inContext:(LRMockyStateMachine *)context;
{
  return [[self alloc] initWithLabel:label context:context];
}

- (id)initWithLabel:(NSString *)aLabel context:(LRMockyStateMachine *)aContext;
{
  if (self = [super init]) {
    label = [aLabel copy];
    context = aContext;
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

- (NSString *)description
{
  return [self state];
}


- (BOOL)isActive;
{
  return [context isCurrentState:self]; 
}

- (void)activate;
{
  [context transitionToState:self];
}

@end
