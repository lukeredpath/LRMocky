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
#import "LRMockyStates.h"
#import "NSInvocation+Conveniences.h"
#import "NSInvocation+OCMAdditions.h"
#import "NSInvocation+LRAdditions.h"

#import <OCHamcrest/HCDescription.h>

NSString *const LRMockyExpectationError = @"LRMockyExpectationError";

@interface LRInvocationExpectation ()
@property (nonatomic, strong) NSInvocation *similarInvocation;
@property (nonatomic, assign) NSUInteger numberOfInvocations;
@end

@implementation LRInvocationExpectation {
  NSInvocation *similarInvocation;
  NSMutableArray *_actions;
  LRMockyState *requiredState;
  BOOL calledWithInvalidState;
}

@synthesize similarInvocation;
@synthesize requiredState;
@synthesize calledWithInvalidState;

- (id)init;
{
  if (self = [super init]) {
    _actions = [[NSMutableArray alloc] init];
    _cardinality = [LRExpectationCardinality atLeast:0];
  }
  return self;
}

- (BOOL)matches:(NSInvocation *)invocation;
{
  if (![self allowsMoreInvocations]) {
    return NO;
  }
  
  if (self.target && self.target != invocation.target) {
    return NO;
  }
  if (self.selector && self.selector != invocation.selector) {
    return NO;
  }
  if (self.parametersMatcher && ![self.parametersMatcher matches:invocation.argumentsArray]) {
    return NO;
  }
  return YES;

//  LRInvocationComparitor *comparitor = [LRInvocationComparitor comparitorForInvocation:expectedInvocation];
//  
//  if ([invocation selector] != [expectedInvocation selector]) {
//    return NO;
//  }
//  if(![comparitor matchesParameters:invocation]) {
//    return NO;
//  }
//  if (self.requiredState && ![self.requiredState isActive]) {
//    NSLog(@"Required state %@ but it is not active", self.requiredState);
//    calledWithInvalidState = YES;
//    return YES;
//  }
}

- (void)invoke:(NSInvocation *)invocation
{
  _numberOfInvocations++;
    
  for (id<LRExpectationAction> action in _actions) {
    [action invoke:invocation];
  }
}

- (BOOL)isSatisfied;
{
  return [self.cardinality isSatisfiedByInvocationCount:self.numberOfInvocations];
}

- (BOOL)allowsMoreInvocations
{
  return [self.cardinality allowsMoreExpectations:self.numberOfInvocations];
}

- (void)describeTo:(id<HCDescription>)description
{
  [description appendText:[NSString stringWithFormat:@"Expected %@ to receive %@ ", self.target, NSStringFromSelector(self.selector)]];
  [self.parametersMatcher describeTo:description];
  [self.cardinality describeTo:description];
  
  if (self.numberOfInvocations == 1) {
    [description appendText:@" but received it only once."];
  }
  else {
    [description appendText:[NSString stringWithFormat:@" but received it %ld times.", self.numberOfInvocations]];
  }
  
//  if (self.similarInvocation && numberOfArguments > 2) {
//    [description appendText:[NSString stringWithFormat:@" %@ was called ", NSStringFromSelector(self.selector)]];
//    
//    NSMutableArray *parameters = [NSMutableArray array];
//    for (int i = 2; i < numberOfArguments; i++) {
//      [parameters addObject:[self.similarInvocation objectDescriptionAtIndex:i]];
//    }
//    [description appendText:[NSString stringWithFormat:@"with arguments: [%@].", [parameters componentsJoinedByString:@", "]]];
//  }
}

- (void)addAction:(id<LRExpectationAction>)anAction;
{
  [_actions addObject:anAction];
}

@end
