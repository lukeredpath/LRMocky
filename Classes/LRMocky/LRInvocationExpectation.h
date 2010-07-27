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
#import "LRDescribable.h"

@protocol LRExpectationCardinality;

@class LRMockObject;

@interface LRInvocationExpectation : NSObject <LRExpectation, LRDescribable> {
  NSInvocation *expectedInvocation;
  NSUInteger numberOfInvocations;
  NSMutableArray *actions;
  id<LRExpectationCardinality> cardinality;
  LRMockObject *mockObject;
}
@property (nonatomic, retain) NSInvocation *invocation;
@property (nonatomic, retain) id<LRExpectationCardinality> cardinality;
@property (nonatomic, retain) LRMockObject *mockObject;

+ (id)expectation;
- (void)addAction:(id<LRExpectationAction>)anAction;
@end
