//
//  LRExpectationCardinality.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRExpectationCardinality.h"
#import "LRExpectationMessage.h"

@implementation LREqualToCardinality

- (id)initWithInt:(NSUInteger)anInt;
{
  if (self = [super init]) {
    equalToInt = anInt;
  }
  return self;
}

- (BOOL)satisfiedBy:(NSUInteger)numberOfInvocations
{
  return numberOfInvocations == equalToInt;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"exactly %ld", equalToInt];
}

- (void)describeTo:(LRExpectationMessage *)message
{
  if (equalToInt == 1) {
    [message append:@"once"];
  }
  else {
    [message append:[NSString stringWithFormat:@"%@ times", [self description]]];
  }
}

@end

id<LRExpectationCardinality> LRM_exactly(NSUInteger anInt)
{
  return [[LREqualToCardinality alloc] initWithInt:anInt];
}

@implementation LRAtLeastCardinality

- (id)initWithMinimum:(NSUInteger)theMinimum;
{
  if (self = [super init]) {
    minimum = theMinimum;
  }
  return self;
}

- (BOOL)satisfiedBy:(NSUInteger)numberOfInvocations
{
  return numberOfInvocations >= minimum;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"at least %ld", minimum];
}

- (void)describeTo:(LRExpectationMessage *)message
{
  [message append:[NSString stringWithFormat:@"%@ times", [self description]]];
}

@end

id<LRExpectationCardinality> LRM_atLeast(NSUInteger anInt)
{
  return [[LRAtLeastCardinality alloc] initWithMinimum:anInt];
}

@implementation LRAtMostCardinality

- (id)initWithMaximum:(NSUInteger)theMaximum;
{
  if (self = [super init]) {
    maximum = theMaximum;
  }
  return self;
}

- (BOOL)satisfiedBy:(NSUInteger)numberOfInvocations
{
  return numberOfInvocations <= maximum;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"at most %ld", maximum];
}

- (void)describeTo:(LRExpectationMessage *)message
{
  [message append:[NSString stringWithFormat:@"%@ times", [self description]]];
}

@end

id<LRExpectationCardinality> LRM_atMost(NSUInteger anInt)
{
  return [[LRAtMostCardinality alloc] initWithMaximum:anInt];
}

@implementation LRBetweenCardinality

- (id)initWithMinimum:(NSUInteger)theMinimum andMaximum:(NSUInteger)theMaximum;
{
  if (self = [super init]) {
    minimum = theMinimum;
    maximum = theMaximum;
  }
  return self;
}

- (BOOL)satisfiedBy:(NSUInteger)numberOfInvocations
{
  return (numberOfInvocations >= minimum && numberOfInvocations <= maximum);
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"between %ld and %ld", minimum, maximum];
}

- (void)describeTo:(LRExpectationMessage *)message
{
  [message append:[NSString stringWithFormat:@"%@ times", [self description]]];
}

@end

id<LRExpectationCardinality> LRM_between(NSUInteger min, NSUInteger max)
{
  return [[LRBetweenCardinality alloc] initWithMinimum:min andMaximum:max];
}
