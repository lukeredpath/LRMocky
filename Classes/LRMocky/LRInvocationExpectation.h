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

@interface LRInvocationExpectation : NSObject <LRExpectation> {
  NSInvocation *expectedInvocation;
  NSUInteger numberOfInvocations;
  NSMutableArray *actions;
}
+ (id)expectationWithInvocation:(NSInvocation *)anInvocation;
- (id)initWithInvocation:(NSInvocation *)anInvocation;
- (void)addAction:(id<LRExpectationAction>)anAction;
@end
