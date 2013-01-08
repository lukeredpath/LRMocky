//
//  LRMockyStateMachine.m
//  Mocky
//
//  Created by Luke Redpath on 30/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRMockyStateMachine.h"

@implementation LRMockyStateMachine {
  NSString *_name;
  NSString *_currentState;
}

- (id)initWithName:(NSString *)aName;
{
  if (self = [super init]) {
    _name = [aName copy];
    [self startsAs:@"<<initial state>>"];
  }
  return self;
}

- (void)startsAs:(NSString *)state;
{
  _currentState = state;
}

- (void)transitionTo:(NSString *)state
{
  _currentState = state;
}

- (id<LRStatePredicate>)equals:(NSString *)stateName
{
  return [[LRMockyState alloc] initWithName:stateName context:self];
}

- (BOOL)isCurrentState:(NSString *)state
{
  return [state isEqualToString:_currentState];
}

@end

#pragma mark -

@implementation LRMockyState {
  NSString *_name;
  LRMockyStateMachine *_context;
}

- (id)initWithName:(NSString *)name context:(LRMockyStateMachine *)context;
{
  if (self = [super init]) {
    _name = [name copy];
    _context = context;
  }
  return self;
}

- (NSString *)description
{
  return _name;
}


- (BOOL)isActive;
{
  return [_context isCurrentState:_name];
}

@end
