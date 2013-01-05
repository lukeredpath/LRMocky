//
//  LRExpectationCardinality.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRExpectationCardinality.h"
#import "LRExpectationMessage.h"

@implementation LRExpectationCardinality

- (id)initWithRequired:(NSUInteger)required maximum:(NSUInteger)maximum
{
  if ((self = [super init])) {
    _required = required;
    _maximium = maximum;
  }
  return self;
}

- (BOOL)isSatisfiedByInvocationCount:(NSUInteger)numberOfInvocationsSoFar
{
  return _required <= numberOfInvocationsSoFar && numberOfInvocationsSoFar <= _maximium;
}

- (BOOL)allowsMoreExpectations:(NSUInteger)invocationCount
{
  return invocationCount < _maximium;
}

- (BOOL)isEqual:(id)object
{
  if (![object isKindOfClass:[LRExpectationCardinality class]]) {
    return NO;
  }
  return [self isEqualToCardinality:object];
}

- (BOOL)isEqualToCardinality:(LRExpectationCardinality *)cardinality
{
  return cardinality.maximium == self.maximium && cardinality.required == self.required;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"<LRExpectationCardinality between:%ld and:%ld>", _required, _maximium];
}

- (void)describeTo:(LRExpectationMessage *)message
{
  if (_required == 0 && _maximium == INT_MAX) {
    [message append:@"any number of times"];
  }
  else {
    if (_required == _maximium) {
      if (_required == 1) {
        [message append:@"exactly once"];
      }
      else {
        [message append:[NSString stringWithFormat:@"exactly %ld times", _required]];
      }
    }
    else if (_required == 0 && _maximium < INT_MAX) {
      [message append:[NSString stringWithFormat:@"a maximum of %ld times", _maximium]];
    }
    else if (_required > 0 && _maximium == INT_MAX) {
      [message append:[NSString stringWithFormat:@"at least %ld times", _required]];
    }
    else if (_required > 0 && _maximium < INT_MAX) {
      [message append:[NSString stringWithFormat:@"between %ld and %ld times", _required, _maximium]];
    }
  }
}

#pragma mark - Factory methods

+ (id)exactly:(NSUInteger)amount
{
  return [[self alloc] initWithRequired:amount maximum:amount];
}

+ (id)atLeast:(NSUInteger)amount
{
  return [[self alloc] initWithRequired:amount maximum:INT_MAX];
}

+ (id)atMost:(NSUInteger)amount
{
  return [[self alloc] initWithRequired:0 maximum:amount];
}

+ (id)between:(NSUInteger)min and:(NSUInteger)max
{
  return [[self alloc] initWithRequired:min maximum:max];
}

@end

@implementation LREqualToCardinality

- (id)initWithInt:(NSUInteger)anInt;
{
  if (self = [super init]) {
    equalToInt = anInt;
  }
  return self;
}

- (BOOL)isSatisfiedByInvocationCount:(NSUInteger)numberOfInvocations
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
  return [LRExpectationCardinality exactly:anInt];
}

@implementation LRAtLeastCardinality

- (id)initWithMinimum:(NSUInteger)theMinimum;
{
  if (self = [super init]) {
    minimum = theMinimum;
  }
  return self;
}

- (BOOL)isSatisfiedByInvocationCount:(NSUInteger)numberOfInvocations
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
  return [LRExpectationCardinality atLeast:anInt];
}

@implementation LRAtMostCardinality

- (id)initWithMaximum:(NSUInteger)theMaximum;
{
  if (self = [super init]) {
    maximum = theMaximum;
  }
  return self;
}

- (BOOL)isSatisfiedByInvocationCount:(NSUInteger)numberOfInvocations
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
  return [LRExpectationCardinality atMost:anInt];
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

- (BOOL)isSatisfiedByInvocationCount:(NSUInteger)numberOfInvocations
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
  return [LRExpectationCardinality between:min and:max];
}
