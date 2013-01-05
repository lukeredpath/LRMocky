//
//  LRExpectationBuilder.h
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRExpectationBuilder.h"
#import "LRExpectation.h"
#import "LRExpectationCardinality.h"
#import "LRExpectationCapture.h"
#import "LRExpectationCollector.h"

@class OLD_LRMockObject;
@class LRMockery;
@class LRInvocationExpectation;
@class LRMockyState;
@class OLD_LRImposterizer;

@interface LRInvocationExpectationBuilder : NSObject <LRExpectationBuilder, LRExpectationCapture, LRExpectationCaptureSyntaticSugar>

#pragma mark - Builder API

- (void)setTarget:(id)target;
- (void)setCardinality:(id<LRExpectationCardinality>)cardinality;
- (id)captureExpectedObject;

@end

#ifdef LRMOCKY_SUGAR
#define mockery()           [LRMockery mockeryForTestCase:self]
#define matching(matcher)   (id)matcher
#endif
