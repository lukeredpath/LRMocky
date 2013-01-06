//
//  LRPerformBlockAction.h
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRExpectationAction.h"

typedef void (^LRInvocationActionBlock)(NSInvocation *);

@interface LRPerformBlockAction : NSObject <LRExpectationAction> {
  LRInvocationActionBlock block;
}
- (id)initWithBlock:(LRInvocationActionBlock)theBlock;
@end
