//
//  LRInvocationExpectation.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRInvocationExpectation.h"
#import "LRExpectationConstraints.h"
#import "LRExpectationCardinality.h"
#import "LRMockyStates.h"
#import "NSInvocation+Conveniences.h"
#import "NSInvocation+OCMAdditions.h"
#import <OCHamcrest/HCDescription.h>

NSString *const LRMockyExpectationError = @"LRMockyExpectationError";

@interface LRInvocationExpectation ()

@property (nonatomic, readonly) NSUInteger numberOfInvocations;
@property (nonatomic, strong) LRCardinalityConstraint *cardinalityConstraint;
@property (nonatomic, strong) id<LRExpectationConstraint> targetConstraint;
@property (nonatomic, strong) id<LRExpectationConstraint> selectorConstraint;
@property (nonatomic, strong) id<LRExpectationConstraint> parametersConstraint;
@property (nonatomic, readonly) NSArray *constraints;

@end

@implementation LRInvocationExpectation

- (id)init;
{
  if (self = [super init]) {
    _targetConstraint = LRCanBeAnythingConstraint();
    _selectorConstraint = LRCanBeAnythingConstraint();
    _parametersConstraint = LRCanBeAnythingConstraint();
    
    [self setCardinality:[LRExpectationCardinality atLeast:0]];
  }
  return self;
}

- (void)setCardinality:(id<LRExpectationCardinality>)cardinality
{
  _cardinality = cardinality;
  _cardinalityConstraint = [LRCardinalityConstraint constraintWithCardinality:cardinality];
}

- (void)setTarget:(id)target
{
  _target = target;
  _targetConstraint = [LRExpectationConstraintUsingBlock constraintWithBlock:^BOOL(NSInvocation *invocation) {
    return invocation.target == target;
  }];
}

- (void)setSelector:(SEL)selector
{
  _selector = selector;
  _selectorConstraint = [LRExpectationConstraintUsingBlock constraintWithBlock:^BOOL(NSInvocation *invocation) {
    return invocation.selector == selector;
  }];
}

- (void)setParametersMatcher:(id<HCMatcher>)parametersMatcher
{
  _parametersMatcher = parametersMatcher;
  _parametersConstraint = [LRExpectationConstraintUsingBlock constraintWithBlock:^BOOL(NSInvocation *invocation) {
    return [parametersMatcher matches:invocation.argumentsArray];
  }];
}

- (NSArray *)constraints
{
  return @[
    self.cardinalityConstraint,
    self.targetConstraint,
    self.selectorConstraint,
    self.parametersConstraint
  ];
}

- (NSUInteger)numberOfInvocations
{
  return self.cardinalityConstraint.invocationCount;
}

- (BOOL)matches:(NSInvocation *)invocation;
{
  for (id<LRExpectationConstraint> constraint in self.constraints) {
    if (![constraint allowsInvocation:invocation]) {
      return NO;
    }
  }
  return YES;
}

- (void)invoke:(NSInvocation *)invocation
{
  [self.cardinalityConstraint incrementInvocationCount];
  [self.action invoke:invocation];
}

- (BOOL)isSatisfied;
{
  return [self.cardinality isSatisfiedByInvocationCount:self.numberOfInvocations];
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

@end
