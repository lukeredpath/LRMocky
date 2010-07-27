//
//  LRInvocationExpectation.h
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRExpectation.h"
#import "LRExpectationAction.h"

@protocol LRExpectationCardinality <NSObject>
- (BOOL)satisfiedBy:(int)numberOfInvocations;
@end    

@interface LRInvocationExpectation : NSObject <LRExpectation> {
  NSInvocation *expectedInvocation;
  NSUInteger numberOfInvocations;
  NSMutableArray *actions;
  id<LRExpectationCardinality> cardinality;
}
@property (nonatomic, retain) NSInvocation *invocation;
@property (nonatomic, retain) id<LRExpectationCardinality> cardinality;

+ (id)expectation;
- (void)addAction:(id<LRExpectationAction>)anAction;
@end

@interface LREqualToCardinality : NSObject <LRExpectationCardinality> {
  int equalToInt;
}
- (id)initWithInt:(int)anInt;
@end

id<LRExpectationCardinality> LRM_expectExactly(int anInt);

@interface LRAtLeastCardinality : NSObject <LRExpectationCardinality> {
  int minimum;
}
- (id)initWithMinimum:(int)theMinimum;
@end

id<LRExpectationCardinality> LRM_atLeast(int anInt);

@interface LRAtMostCardinality : NSObject <LRExpectationCardinality> {
  int maximum;
}
- (id)initWithMaximum:(int)theMaximum;
@end

id<LRExpectationCardinality> LRM_atMost(int anInt);

