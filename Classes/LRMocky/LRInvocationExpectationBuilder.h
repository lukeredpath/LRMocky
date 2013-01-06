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

@interface LRInvocationExpectationBuilder : NSObject <LRExpectationBuilder, LRExpectationCapture, LRExpectationCaptureSyntaticSugar>

#pragma mark - Builder API

- (void)setTarget:(id)target;
- (void)setCardinality:(id<LRExpectationCardinality>)cardinality;
- (void)setAction:(id<LRExpectationAction>)action;

#pragma mark - Invocation capture

- (id)captureExpectedObject;

@end

#ifdef LRMOCKY_SUGAR
#define mockery()           [LRMockery mockeryForTestCase:self]
#define matching(matcher)   (id)matcher
#endif
