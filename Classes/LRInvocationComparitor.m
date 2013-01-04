//
//  LRInvocationComparitor.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRInvocationComparitor.h"
#import "NSInvocation+OCMAdditions.h"
#import "LRHamcrestSupport.h"

@implementation LRInvocationComparitor

+ (id)comparitorForInvocation:(NSInvocation *)invocation;
{
  return [[self alloc] initWithInvocation:invocation];
}

- (id)initWithInvocation:(NSInvocation *)anInvocation;
{
  if (self = [super init]) {
    expectedInvocation = anInvocation;
    [expectedInvocation retainArguments];
  }
  return self;
}


- (BOOL)matchesParameters:(NSInvocation *)invocation;
{
  NSMethodSignature *methodSignature = [expectedInvocation methodSignature];
  
  BOOL matchesParameters = YES;
  for (int i = 2; i < [methodSignature numberOfArguments]; i++) {
    id expected = [expectedInvocation getArgumentAtIndexAsObject:i];
    id received = [invocation getArgumentAtIndexAsObject:i];

    if ([expected conformsToProtocol:NSProtocolFromString(@"HCMatcher")]) {
      matchesParameters = [expected matches:received];
    }
    else {
      matchesParameters = [expected isEqual:received]; 
    }
  }
  return matchesParameters;
}

@end
