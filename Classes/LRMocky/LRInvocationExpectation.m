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
@property (nonatomic, strong) id<LRExpectationConstraint> stateConstraint;
@property (nonatomic, readonly) NSArray *constraints;

@end

@implementation LRInvocationExpectation

- (id)init;
{
  if (self = [super init]) {
    self.target = nil;
    self.selector = nil;
    self.cardinality = nil;
    self.parametersMatcher = nil;
    self.statePredicate = nil;
    
    [self setCardinality:[LRExpectationCardinality atLeast:0]];
  }
  return self;
}

- (void)setCardinality:(id<LRExpectationCardinality>)cardinality
{
  _cardinality = cardinality;
  
  if (_cardinality) {
    _cardinalityConstraint = [LRCardinalityConstraint constraintWithCardinality:cardinality];
  }
  else {
    _cardinalityConstraint = LRCanBeAnythingConstraint();
  }
}

- (void)setTarget:(id)target
{
  _target = target;
  
  if (_target) {
    _targetConstraint = [LRExpectationConstraintUsingBlock constraintWithBlock:^BOOL(NSInvocation *invocation) {
      return invocation.target == target;
    }];
  }
  else {
    _targetConstraint = LRCanBeAnythingConstraint();
  }
}

- (void)setSelector:(SEL)selector
{
  _selector = selector;
  
  if (_selector) {
    _selectorConstraint = [LRExpectationConstraintUsingBlock constraintWithBlock:^BOOL(NSInvocation *invocation) {
      return invocation.selector == selector;
    }];
  }
  else {
    _selectorConstraint = LRCanBeAnythingConstraint();
  }
}

- (void)setParametersMatcher:(id<HCMatcher>)parametersMatcher
{
  _parametersMatcher = parametersMatcher;
  
  if (_parametersMatcher) {
    _parametersConstraint = [LRExpectationConstraintUsingBlock constraintWithBlock:^BOOL(NSInvocation *invocation) {
      return [parametersMatcher matches:invocation.argumentsArray];
    }];
  }
  else {
    _parametersConstraint = LRCanBeAnythingConstraint();
  }
}

- (void)setStatePredicate:(id<LRStatePredicate>)statePredicate
{
  _statePredicate = statePredicate;
  
  if (_statePredicate) {
    _stateConstraint = [LRExpectationConstraintUsingBlock constraintWithBlock:^BOOL(NSInvocation *invocation) {
      return [statePredicate isActive];
    }];
  }
  else {
    _stateConstraint = LRCanBeAnythingConstraint();
  }
}

- (NSArray *)constraints
{
  return @[
    self.cardinalityConstraint,
    self.targetConstraint,
    self.selectorConstraint,
    self.parametersConstraint,
    self.stateConstraint
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
