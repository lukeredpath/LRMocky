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
- (BOOL)satisfiedBy:(int)numberOfInvocations;
@end

@interface LREqualToCardinality : NSObject <LRExpectationCardinality> {
  int equalToInt;
}
- (id)initWithInt:(int)anInt;
@end

id<LRExpectationCardinality> LRM_exactly(int anInt);

#ifdef MOCKY_SHORTHAND
  #define exactly(int) LRM_exactly(int)
  #define times(int)   LRM_exactly(int)
#endif

@interface LRAtLeastCardinality : NSObject <LRExpectationCardinality> {
  int minimum;
}
- (id)initWithMinimum:(int)theMinimum;
@end

id<LRExpectationCardinality> LRM_atLeast(int anInt);

#ifdef MOCKY_SHORTHAND
  #define atLeast(min) LRM_atLeast(min)
#endif

@interface LRAtMostCardinality : NSObject <LRExpectationCardinality> {
  int maximum;
}
- (id)initWithMaximum:(int)theMaximum;
@end

id<LRExpectationCardinality> LRM_atMost(int anInt);

#ifdef MOCKY_SHORTHAND
  #define atMost(max) LRM_atMost(max)
#endif

@interface LRBetweenCardinality : NSObject <LRExpectationCardinality> {
  int minimum;
  int maximum;
}
- (id)initWithMinimum:(int)theMinimum andMaximum:(int)theMaximum;
@end

id<LRExpectationCardinality> LRM_between(int min, int max);

#ifdef MOCKY_SHORTHAND
  #define between(min, max) LRM_between(min, max)
#endif

