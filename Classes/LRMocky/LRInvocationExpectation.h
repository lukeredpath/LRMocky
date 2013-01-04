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

@class OLD_LRMockObject;
@class LRMockyState;

@interface LRInvocationExpectation : NSObject <LRExpectation> {
  NSInvocation *expectedInvocation;
  NSInvocation *similarInvocation;
  NSUInteger numberOfInvocations;
  NSMutableArray *actions;
  id<LRExpectationCardinality> cardinality;
  id mockObject;
  LRMockyState *requiredState;
  BOOL calledWithInvalidState;
}
@property (nonatomic, strong) NSInvocation *invocation;
@property (nonatomic, strong) id<LRExpectationCardinality> cardinality;
@property (nonatomic, strong) OLD_LRMockObject *mockObject;
@property (nonatomic, strong) LRMockyState *requiredState;
@property (nonatomic, readonly) BOOL calledWithInvalidState;

+ (id)expectationWithObject:(OLD_LRMockObject *)mockObject;
- (void)addAction:(id<LRExpectationAction>)anAction;
- (void)setInvocation:(NSInvocation *)invocation;
@end
