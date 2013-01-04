//
//  LRExpectationCardinality.h
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRDescribable.h"

@protocol LRExpectationCardinality <NSObject, LRDescribable>
- (BOOL)satisfiedBy:(NSUInteger)numberOfInvocations;
@end

@interface LREqualToCardinality : NSObject <LRExpectationCardinality> {
  NSUInteger equalToInt;
}
- (id)initWithInt:(NSUInteger)anInt;
@end

id<LRExpectationCardinality> LRM_exactly(NSUInteger anInt);

#ifdef MOCKY_SHORTHAND
  #define exactly(int) LRM_exactly(int)
  #define times(int)   LRM_exactly(int)
#endif

@interface LRAtLeastCardinality : NSObject <LRExpectationCardinality> {
  NSUInteger minimum;
}
- (id)initWithMinimum:(NSUInteger)theMinimum;
@end

id<LRExpectationCardinality> LRM_atLeast(NSUInteger anInt);

#ifdef MOCKY_SHORTHAND
  #define atLeast(min) LRM_atLeast(min)
#endif

@interface LRAtMostCardinality : NSObject <LRExpectationCardinality> {
  NSUInteger maximum;
}
- (id)initWithMaximum:(NSUInteger)theMaximum;
@end

id<LRExpectationCardinality> LRM_atMost(NSUInteger anInt);

#ifdef MOCKY_SHORTHAND
  #define atMost(max) LRM_atMost(max)
#endif

@interface LRBetweenCardinality : NSObject <LRExpectationCardinality> {
  NSUInteger minimum;
  NSUInteger maximum;
}
- (id)initWithMinimum:(NSUInteger)theMinimum andMaximum:(NSUInteger)theMaximum;
@end

id<LRExpectationCardinality> LRM_between(NSUInteger min, NSUInteger max);

#ifdef MOCKY_SHORTHAND
  #define between(min, max) LRM_between(min, max)
#endif

