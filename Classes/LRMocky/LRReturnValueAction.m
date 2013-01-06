//
//  LRReturnValueAction.m
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRReturnValueAction.h"
#import "NSInvocation+Conveniences.h"

@implementation LRReturnValueAction {
  id _returnValue;
}

- (id)initWithReturnValue:(id)returnValue
{
  if ((self = [super init])) {
    _returnValue = returnValue;
  }
  return self;
}

- (void)invoke:(NSInvocation *)invocation
{
  [invocation setReturnValueFromObject:_returnValue];
}

@end
