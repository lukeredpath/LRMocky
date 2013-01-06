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
