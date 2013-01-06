//
//  LRExpectationCardinality.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRExpectationCardinality.h"

#import <OCHamcrest/HCDescription.h>

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

- (void)describeTo:(id<HCDescription>)description
{
  if (_required == 0 && _maximium == INT_MAX) {
    [description appendText:@"any number of times"];
  }
  else {
    if (_required == _maximium) {
      if (_required == 1) {
        [description appendText:@"exactly once"];
      }
      else {
        [description appendText:[NSString stringWithFormat:@"exactly %ld times", _required]];
      }
    }
    else if (_required == 0 && _maximium < INT_MAX) {
      [description appendText:[NSString stringWithFormat:@"a maximum of %ld times", _maximium]];
    }
    else if (_required > 0 && _maximium == INT_MAX) {
      [description appendText:[NSString stringWithFormat:@"at least %ld times", _required]];
    }
    else if (_required > 0 && _maximium < INT_MAX) {
      [description appendText:[NSString stringWithFormat:@"between %ld and %ld times", _required, _maximium]];
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
