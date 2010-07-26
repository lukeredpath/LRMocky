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
    actions = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc;
{
  [actions release];
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
  
  for (id<LRExpectationAction> action in actions) {
    [action invoke:invocation];
  }
}

- (BOOL)isSatisfied;
{
  return numberOfInvocations > 0;
}

- (NSException *)failureException;
{
  return [NSException exceptionWithName:@"test failure" reason:@"just testing" userInfo:nil];
}

- (void)addAction:(id<LRExpectationAction>)anAction;
{
  [actions addObject:anAction];
}

@end
