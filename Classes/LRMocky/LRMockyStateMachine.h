//
//  LRMockyStateMachine.h
//  Mocky
//
//  Created by Luke Redpath on 30/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRStatePredicate.h"

@class LRMockyState;

@interface LRMockyStateMachine : NSObject

@property (nonatomic, readonly) NSString *currentState;

- (id)initWithName:(NSString *)aName;
- (id)startsAs:(NSString *)state;
- (id)transitionTo:(NSString *)state;
- (BOOL)isCurrentState:(NSString *)state;
- (id<LRStatePredicate>)equals:(NSString *)state;

@end

@interface LRMockyState : NSObject <LRStatePredicate>

- (id)initWithName:(NSString *)name context:(LRMockyStateMachine *)context;

@end
