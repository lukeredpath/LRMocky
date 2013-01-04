//
//  LRPerformBlockAction.m
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRPerformBlockAction.h"


@implementation LRPerformBlockAction

- (id)initWithBlock:(LRInvocationActionBlock)theBlock;
{
  if (self = [super init]) {
    block = [theBlock copy];
  }
  return self;
}


- (void)invoke:(NSInvocation *)invocation
{
  block(invocation);
}

@end

LRPerformBlockAction *LRA_performBlock(LRInvocationActionBlock theBlock)
{
  return [[LRPerformBlockAction alloc] initWithBlock:theBlock];
}
