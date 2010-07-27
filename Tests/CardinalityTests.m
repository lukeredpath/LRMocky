//
//  CardinalityTests.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#define LRMOCKY_SHORTHAND
#define LRMOCKY_SUGAR

#import "TestHelper.h"
#import "LRMocky.h"
#import "FunctionalMockeryTestCase.h"

@interface CardinalityTests : FunctionalMockeryTestCase
@end

@implementation CardinalityTests

#pragma mark Exactly (x) times

- (void)testCanSpecifyExpectationIsCalledOnceAndFailIfCalledTwice
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, failedWithNumberOfFailures(1));
}

- (void)testCanSpecifyExpectationIsCalledExactNumberOfTimesAndFailIfCalledFewerTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[exactly(3) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, failedWithNumberOfFailures(1));
}

- (void)testCanSpecifyExpectationIsCalledExactNumberOfTimesAndFailIfCalledMoreTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[exactly(2) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, failedWithNumberOfFailures(1));
}

#pragma mark At least (x) times

- (void)testCanSpecifyExpectationIsCalledAtLeastNumberOfTimesAndFailIfCalledFewerTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[atLeast(2) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, failedWithNumberOfFailures(1));
}

- (void)testCanSpecifyExpectationIsCalledAtLeastNumberOfTimesAndPassIfCalledMoreTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[atLeast(2) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanSpecifyExpectationIsCalledAtLeastNumberOfTimesAndPassIfCalledTheExactNumberOfTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[atLeast(2) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

#pragma mark At most (x) times

- (void)testCanSpecifyExpectationIsCalledAtMostNumberOfTimesAndFailIfCalledMoreTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[atMost(2) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, failedWithNumberOfFailures(1));
}

- (void)testCanSpecifyExpectationIsCalledAtMostNumberOfTimesAndPassIfCalledFewerTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[atMost(2) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanSpecifyExpectationIsCalledAtMostNumberOfTimesAndPassIfCalledTheExactNumberOfTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[atMost(2) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

#pragma mark Between (x) and (y) times

- (void)testCanSpecifyExpectationIsCalledBetweenNumberOfTimesAndFailIfCalledMoreTimesThanTheUpperLimit
{
  [context checking:^(LRExpectationBuilder *builder){
    [[between(2, 5) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, failedWithNumberOfFailures(1));
}

- (void)testCanSpecifyExpectationIsCalledBetweenNumberOfTimesAndFailIfCalledFewerTimesThanTheLowerLimit
{
  [context checking:^(LRExpectationBuilder *builder){
    [[between(2, 5) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, failedWithNumberOfFailures(1));
}

- (void)testCanSpecifyExpectationIsCalledBetweenNumberOfTimesAndPassIfCalledLowerLimitTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[between(2, 5) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanSpecifyExpectationIsCalledBetweenNumberOfTimesAndPassIfCalledUpperLimitTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[between(2, 5) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanSpecifyExpectationIsCalledBetweenNumberOfTimesAndPassIfCalledBetweenUpperAndLowerLimitTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[between(2, 5) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}


@end
