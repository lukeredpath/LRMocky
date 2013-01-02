//
//  LRExpectationBuilder.h
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRExpectation.h"
#import "LRExpectationCardinality.h"

@class LRMockObject;
@class LRMockery;
@class LRInvocationExpectation;
@class LRMockyState;
@class LRImposterizer;

@interface LRExpectationBuilder : NSObject

@property (nonatomic, readonly) id<LRExpectation> expectation;

+ (void)buildExpectationsWithBlock:(dispatch_block_t)expectationBlock inContext:(LRMockery *)context;
+ (LRExpectationBuilder *)currentExpectationBuilder;

#pragma mark - Configuring expectations

/* No-op - simply returns self.
 
 This method is provided purely as syntatic sugar to make your expectations read more fluently.
 
 It is the equivalent of calling receives:exactly(1).
 */
- (id)receives;

/* Assert that the expectation target will receive the expected message with the given 
 cardinality.
 
 Cardinality objects should be created using the factory functions defined in LRExpectationCardinality.h
 */
- (id)receives:(id<LRExpectationCardinality>)cardinality;

/* Syntatic sugar for calling receives: with LRM_exactly(0) cardinality.
 */
- (id)neverReceives;

/* Sets the target for the expectation.
 
 Not normally called directly - use the expectThat() macro to call this method on the global expectation
 builder within a setExpectations: block.
 */
- (id)setExpectationTarget:(id)object;

/* No-op - simple returns self.
 
 Syntatic sugar, designed to be used following a call to receives:cardinality.
 
 e.g. instead of:
   [[expectThat(object) receives:atLeast(1)] someMethod];
 
 You can write:
   [[[expectThat(object) receives:atLeast(1)] of] someMethod];
 */
- (id)of;

/* Specifies an action that should occur when the expectation is met.
 */
- (id)then:(id<LRExpectationAction>)action;

#pragma mark - Deprecated syntax

- (void)shouldTransitionToState:(LRMockyState *)state;
- (void)requiresState:(LRMockyState *)state;

@end

#pragma mark - Global expectation builder proxy macros

#define expectThat(object) [[LRExpectationBuilder currentExpectationBuilder] setExpectationTarget:object]
#define allowing(object)   [expectThat(object) receives:LRM_atLeast(0)]
#define and                [LRExpectationBuilder currentExpectationBuilder]

#ifdef LRMOCKY_SUGAR
#define mockery()           [LRMockery mockeryForTestCase:self]
#define matching(matcher)   (id)matcher
#endif
