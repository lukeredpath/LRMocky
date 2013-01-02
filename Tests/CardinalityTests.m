//
//  CardinalityTests.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "FunctionalMockeryTestCase.h"

DEFINE_FUNCTIONAL_TEST_CASE(CardinalityTests)

#pragma mark Exactly (x) times

- (void)testCanSpecifyExpectationIsCalledOnceAndFailIfCalledTwice
{
  [context setExpectations:^{
    [[expectThat(testObject) receives] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  
  [context assertSatisfied];

  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething once but received it 2 times.", testObject]));
}

- (void)testCanSpecifyExpectationIsCalledExactNumberOfTimesAndFailIfCalledFewerTimes
{
  [context setExpectations:^{
    [[expectThat(testObject) receives:exactly(3)] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething exactly 3 times but received it 2 times.", testObject]));
}

- (void)testCanSpecifyExpectationIsCalledExactNumberOfTimesAndFailIfCalledMoreTimes
{
  [context setExpectations:^{
    [[[expectThat(testObject) receives:exactly(2)] of] doSomething];
  }];

  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething exactly 2 times but received it 3 times.", testObject]));
}

#pragma mark At least (x) times

- (void)testCanSpecifyExpectationIsCalledAtLeastNumberOfTimesAndFailIfCalledFewerTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[[expectThat(testObject) receives:atLeast(2)] of] doSomething];
  }];
  
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething at least 2 times but received it only once.", testObject]));
}

- (void)testCanSpecifyExpectationIsCalledAtLeastNumberOfTimesAndPassIfCalledMoreTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[[expectThat(testObject) receives:atLeast(2)] of] doSomething];
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
    [[[expectThat(testObject) receives:atLeast(2)] of] doSomething];
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
    [[[expectThat(testObject) receives:atMost(2)] of] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething at most 2 times but received it 3 times.", testObject]));
}

- (void)testCanSpecifyExpectationIsCalledAtMostNumberOfTimesAndPassIfCalledFewerTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[[expectThat(testObject) receives:atMost(2)] of] doSomething];
  }];
  
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanSpecifyExpectationIsCalledAtMostNumberOfTimesAndPassIfCalledTheExactNumberOfTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[[expectThat(testObject) receives:atMost(2)] of] doSomething];
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
    [[[expectThat(testObject) receives:between(2, 5)] of] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];

  [context assertSatisfied];
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething between 2 and 5 times but received it 6 times.", testObject]));
}

- (void)testCanSpecifyExpectationIsCalledBetweenNumberOfTimesAndFailIfCalledFewerTimesThanTheLowerLimit
{
  [context checking:^(LRExpectationBuilder *builder){
    [[[expectThat(testObject) receives:between(2, 5)] of] doSomething];
  }];
  
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething between 2 and 5 times but received it only once.", testObject]));
}

- (void)testCanSpecifyExpectationIsCalledBetweenNumberOfTimesAndPassIfCalledLowerLimitTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[[expectThat(testObject) receives:between(2, 5)] of] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanSpecifyExpectationIsCalledBetweenNumberOfTimesAndPassIfCalledUpperLimitTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[[expectThat(testObject) receives:between(2, 5)] of] doSomething];
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
    [[[expectThat(testObject) receives:between(2, 5)] of] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

#pragma mark Never allowed

- (void)testCanSpecifyExpectationIsNotAllowedAndFailIfItIsCalled
{
  [context checking:^(LRExpectationBuilder *builder){
    [[expectThat(testObject) neverReceives] doSomething];
  }];
  
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething exactly 0 times but received it only once.", testObject]));
}

- (void)testCanSpecifyExpectationIsNotAllowedAndPassIfItIsNotCalled
{
  [context checking:^(LRExpectationBuilder *builder){
    [[expectThat(testObject) neverReceives] doSomething];
  }];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

END_TEST_CASE
