//
//  LRExpectation.h
//  Mocky
//
//  Created by Luke Redpath on 22/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRExpectationAction.h"

@protocol LRExpectation <NSObject>
- (BOOL)matches:(NSInvocation *)invocation;
- (void)invoke:(NSInvocation *)invocation;
- (BOOL)isSatisfied;
- (NSException *)failureException;
- (void)addAction:(id<LRExpectationAction>)action;
@end
