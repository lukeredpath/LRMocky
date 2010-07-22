//
//  LRInvocationExpectation.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRInvocationExpectation.h"


@implementation LRInvocationExpectation

+ (id)expectationWithInvocation:(NSInvocation *)anInvocation;
{
  return [[[self alloc] initWithInvocation:anInvocation] autorelease];
}

- (id)initWithInvocation:(NSInvocation *)anInvocation;
{
  if (self = [super init]) {
    expectedInvocation = [anInvocation retain];
    numberOfInvocations = 0;
  }
  return self;
}

- (void)dealloc;
{
  [expectedInvocation release];
  [super dealloc];
}

- (BOOL)matches:(NSInvocation *)invocation;
{
  if ([invocation selector] != [expectedInvocation selector]) {
    return NO;
  }
  return YES;
}

- (void)invoke:(NSInvocation *)invocation
{
  numberOfInvocations++;
}

- (BOOL)isSatisfied;
{
  return numberOfInvocations > 0;
}

- (NSException *)failureException;
{
  return [NSException exceptionWithName:@"test failure" reason:@"just testing" userInfo:nil];
}

@end
