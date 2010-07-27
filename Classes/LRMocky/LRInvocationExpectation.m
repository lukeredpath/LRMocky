//
//  LRInvocationExpectation.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRInvocationExpectation.h"
#import "LRInvocationComparitor.h"

@implementation LRInvocationExpectation

@synthesize invocation = expectedInvocation;

+ (id)expectation;
{
  return [[[self alloc] init] autorelease];
}

- (id)init;
{
  if (self = [super init]) {
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
  LRInvocationComparitor *comparitor = [LRInvocationComparitor comparitorForInvocation:expectedInvocation];
  
  if([comparitor matchesParameters:invocation]) {
    numberOfInvocations++;
    
    for (id<LRExpectationAction> action in actions) {
      [action invoke:invocation];
    } 
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
