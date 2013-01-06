//
//  LRExpectationConstraints.m
//  Mocky
//
//  Created by Luke Redpath on 06/01/2013.
//
//

#import "LRExpectationConstraints.h"

@implementation LRExpectationConstraintUsingBlock {
  LRExpectationInvocationBlock _block;
}

+ (id)constraintWithBlock:(LRExpectationInvocationBlock)block
{
  return [[self alloc] initWithBlock:block];
}

- (id)initWithBlock:(LRExpectationInvocationBlock)block
{
  self = [super init];
  if (self) {
    _block = [block copy];
  }
  return self;
}

- (BOOL)allowsInvocation:(NSInvocation *)invocation
{
  return _block(invocation);
}

@end

#pragma mark -

@implementation LRInCorrectStateConstraint

+ (id)constraintWithState:(id)state
{
  return nil; // TODO
}

- (BOOL)allowsInvocation:(NSInvocation *)invocation
{
  return NO;
}

@end

#pragma mark -

@implementation LRCardinalityConstraint {
  id<LRExpectationCardinality> _cardinality;
}

+ (id)constraintWithCardinality:(id<LRExpectationCardinality>)cardinality
{
  return [[self alloc] initWithCardinality:cardinality];
}

- (id)initWithCardinality:(id<LRExpectationCardinality>)cardinality;
{
  self = [super init];
  if (self) {
    _cardinality = cardinality;
  }
  return self;
}

- (BOOL)allowsInvocation:(NSInvocation *)invocation
{
  return [_cardinality allowsMoreExpectations:_invocationCount];
}

- (void)incrementInvocationCount
{
  _invocationCount++;
}

@end

#pragma mark -

id<LRExpectationConstraint> LRCanBeAnythingConstraint(void)
{
  return [LRExpectationConstraintUsingBlock constraintWithBlock:^BOOL(NSInvocation *invocation) {
    return YES;
  }];
}
