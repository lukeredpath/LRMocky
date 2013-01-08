//
//  LRExpectationBuilder.h
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRExpectationBuilder.h"
#import "LRExpectationCapture.h"
#import "LRExpectationCardinality.h"
#import "LRExpectationAction.h"
#import "LRStatePredicate.h"
#import "LRInvokable.h"

@interface LRInvocationExpectationBuilder : NSObject <LRExpectationBuilder, LRInvokable, LRExpectationCaptureSyntaticSugar>

#pragma mark - Builder API

- (void)setTarget:(id)target;
- (void)setCardinality:(id<LRExpectationCardinality>)cardinality;
- (void)setAction:(id<LRExpectationAction>)action;
- (void)setStatePredicate:(id<LRStatePredicate>)statePredicate;

#pragma mark - Invocation capture

- (id)captureExpectedObject;

@end

#ifdef LRMOCKY_SUGAR
#define mockery()           [LRMockery mockeryForTestCase:self]
#define matching(matcher)   (id)matcher
#endif
