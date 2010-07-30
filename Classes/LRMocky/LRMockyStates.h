//
//  LRMockyStates.h
//  Mocky
//
//  Created by Luke Redpath on 30/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRMockyState;

@interface LRMockyStates : NSObject {
  NSString *name;
  LRMockyState *currentState;
}
- (id)initWithName:(NSString *)aName;
- (id)initWithName:(NSString *)aName defaultState:(NSString *)label;
- (void)transitionToState:(LRMockyState *)newState;
- (BOOL)isCurrentState:(LRMockyState *)state;
- (LRMockyState *)state:(NSString *)label;
- (LRMockyState *)becomes:(NSString *)label;
- (LRMockyState *)inState:(NSString *)label;
@end

@interface LRMockyState : NSObject
{
  NSString *label;
  LRMockyStates *context;
}
+ (id)stateWithLabel:(NSString *)label inContext:(LRMockyStates *)context;
- (id)initWithLabel:(NSString *)aLabel context:(LRMockyStates *)aContext;
- (void)transitionToState;
- (BOOL)isCurrentState;
- (BOOL)isEqualToState:(LRMockyState *)state;
- (BOOL)matches:(NSString *)stateLabel;
@end

