//
//  LRExpectation.h
//  Mocky
//
//  Created by Luke Redpath on 22/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRExpectationAction.h"
#import "LRStatePredicate.h"
#import <OCHamcrest/HCSelfDescribing.h>

extern NSString *const LRMockyExpectationError;

@protocol LRExpectation <NSObject, HCSelfDescribing>

@property (nonatomic, strong) id<LRExpectationAction> action;
@property (nonatomic, strong) id<LRStatePredicate> statePredicate;

- (BOOL)isSatisfied;
- (BOOL)matches:(NSInvocation *)invocation;
- (void)invoke:(NSInvocation *)invocation;

@end
