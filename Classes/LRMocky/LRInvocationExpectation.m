//
//  LRInvocationExpectation.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRInvocationExpectation.h"
#import "LRInvocationComparitor.h"
#import "LRExpectationCardinality.h"
#import "LRExpectationMessage.h"
#import "NSInvocation+OCMAdditions.h"

NSString *const LRMockyExpectationError = @"LRMockyExpectationError";

@interface LRInvocationExpectation ()
@property (nonatomic, retain) NSInvocation *similarInvocation;
@end

@implementation LRInvocationExpectation

@synthesize invocation = expectedInvocation;
@synthesize cardinality;
@synthesize mockObject;
@synthesize similarInvocation;

+ (id)expectation;
{
  return [[[self alloc] init] autorelease];
}

- (id)init;
{
  if (self = [super init]) {
    numberOfInvocations = 0;
    actions = [[NSMutableArray alloc] init];
    self.cardinality = LRM_expectExactly(1); // TODO choose a better default
  }
  return self;
}

- (void)dealloc;
{
  [mockObject release];
  [cardinality release];
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
  } else {
    [invocation retainArguments];
    self.similarInvocation = invocation;
  }
}

- (BOOL)isSatisfied;
{
  return [self.cardinality satisfiedBy:numberOfInvocations];
}

- (NSException *)failureException;
{
  LRExpectationMessage *errorMessage = [[[LRExpectationMessage alloc] init] autorelease];
  [self describeTo:errorMessage];
  return [NSException exceptionWithName:LRMockyExpectationError reason:errorMessage.message userInfo:nil];
}

- (void)describeTo:(LRExpectationMessage *)message
{
  [message append:[NSString stringWithFormat:@"Expected %@ to receive %@ ", mockObject, NSStringFromSelector([expectedInvocation selector])]];
  
  NSInteger numberOfArguments = [[expectedInvocation methodSignature] numberOfArguments];
  if (numberOfArguments > 2) {
    NSMutableArray *parameters = [NSMutableArray array];
    for (int i = 2; i < numberOfArguments; i++) {
      [parameters addObject:[expectedInvocation objectDescriptionAtIndex:i]];
    }
    [message append:[NSString stringWithFormat:@"with(%@) ", [parameters componentsJoinedByString:@", "]]];
  } 
  
  [self.cardinality describeTo:message];
  [message append:[NSString stringWithFormat:@" but received it %d times.", numberOfInvocations]];
  
  if (self.similarInvocation && numberOfArguments > 2) {
    [message append:[NSString stringWithFormat:@" %@ was called ", NSStringFromSelector([expectedInvocation selector])]];
    
    NSMutableArray *parameters = [NSMutableArray array];
    for (int i = 2; i < numberOfArguments; i++) {
      [parameters addObject:[self.similarInvocation objectDescriptionAtIndex:i]];
    }
    [message append:[NSString stringWithFormat:@"with(%@).", [parameters componentsJoinedByString:@", "]]];
  }
}

- (void)addAction:(id<LRExpectationAction>)anAction;
{
  [actions addObject:anAction];
}

@end

