//
//  LRInvocationExpectation.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRInvocationExpectation.h"

@interface LRInvocationExpectation ()
- (BOOL)calledWithCorrectParameters:(NSInvocation *)invocation;
@end

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
  if([self calledWithCorrectParameters:invocation]) {
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

#pragma mark Private methods

- (BOOL)calledWithCorrectParameters:(NSInvocation *)invocation
{
  NSMethodSignature *methodSignature = [invocation methodSignature];
  
  BOOL parametersAreCorrect = YES;
  for (int i = 2; i < [methodSignature numberOfArguments]; i++) {
    const char *argType = [methodSignature getArgumentTypeAtIndex:i];
  
    if (*argType == *@encode(id)) {
      id receivedArg;
      id expectedArg;
      
      [invocation getArgument:&receivedArg atIndex:i];
      [expectedInvocation getArgument:&expectedArg atIndex:i];
      
      parametersAreCorrect = [receivedArg isEqual:expectedArg];
    } 
    else if(*argType == *@encode(int))
    {
      int receivedArg;
      int expectedArg;
      
      [invocation getArgument:&receivedArg atIndex:i];
      [expectedInvocation getArgument:&expectedArg atIndex:i];
      
      parametersAreCorrect = (receivedArg == expectedArg);
    }
    else
    {
      NSLog(@"Unknown argType %c", *argType);
      parametersAreCorrect = NO;
    }
  }
  return parametersAreCorrect;
}

@end
