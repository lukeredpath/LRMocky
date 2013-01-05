//
//  LRExpectationCardinality.h
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCSelfDescribing.h"

@protocol LRExpectationCardinality <NSObject, HCSelfDescribing>

- (BOOL)isSatisfiedByInvocationCount:(NSUInteger)numberOfInvocationsSoFar;
- (BOOL)allowsMoreExpectations:(NSUInteger)invocationCount;

@end

@interface LRExpectationCardinality : NSObject <LRExpectationCardinality>

@property (nonatomic, readonly) NSUInteger required;
@property (nonatomic, readonly) NSUInteger maximium;

- (id)initWithRequired:(NSUInteger)required maximum:(NSUInteger)maximum;

#pragma mark - Factory methods

+ (id)exactly:(NSUInteger)amount;
+ (id)atLeast:(NSUInteger)amount;
+ (id)atMost:(NSUInteger)amount;
+ (id)between:(NSUInteger)min and:(NSUInteger)max;

@end

@interface LREqualToCardinality : NSObject {
  NSUInteger equalToInt;
}
- (id)initWithInt:(NSUInteger)anInt;
@end

id<LRExpectationCardinality> LRM_exactly(NSUInteger anInt);

#ifdef MOCKY_SHORTHAND
  #define exactly(int) LRM_exactly(int)
  #define times(int)   LRM_exactly(int)
#endif

@interface LRAtLeastCardinality : NSObject {
  NSUInteger minimum;
}
- (id)initWithMinimum:(NSUInteger)theMinimum;
@end

id<LRExpectationCardinality> LRM_atLeast(NSUInteger anInt);

#ifdef MOCKY_SHORTHAND
  #define atLeast(min) LRM_atLeast(min)
#endif

@interface LRAtMostCardinality : NSObject {
  NSUInteger maximum;
}
- (id)initWithMaximum:(NSUInteger)theMaximum;
@end

id<LRExpectationCardinality> LRM_atMost(NSUInteger anInt);

#ifdef MOCKY_SHORTHAND
  #define atMost(max) LRM_atMost(max)
#endif

@interface LRBetweenCardinality : NSObject {
  NSUInteger minimum;
  NSUInteger maximum;
}
- (id)initWithMinimum:(NSUInteger)theMinimum andMaximum:(NSUInteger)theMaximum;
@end

id<LRExpectationCardinality> LRM_between(NSUInteger min, NSUInteger max);

#ifdef MOCKY_SHORTHAND
  #define between(min, max) LRM_between(min, max)
#endif

