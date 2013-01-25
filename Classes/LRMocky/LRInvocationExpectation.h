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
#import "LRStatePredicate.h"
#import "HCSelfDescribing.h"
#import <OCHamcrest/HCMatcher.h>

@protocol LRExpectationCardinality;

@class LRMockyState;

@interface LRInvocationExpectation : NSObject <LRExpectation>

@property (nonatomic, strong) id<LRExpectationCardinality> cardinality;
@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) id<HCMatcher> parametersMatcher;

@end
