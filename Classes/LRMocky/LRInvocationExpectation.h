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
