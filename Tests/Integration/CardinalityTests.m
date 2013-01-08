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

- (void)testCanSpecifyExpectationIsCalledExactNumberOfTimesAndFailIfCalledFewerTimes
{
  [context check:^{
    [[expectThat(testObject) receivesExactly:3] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething exactly 3 times but received it 2 times.", testObject]));
}

- (void)testCanSpecifyExpectationIsCalledExactNumberOfTimesAndFailIfCalledMoreTimes
{
  [context check:^{
    [[[expectThat(testObject) receivesExactly:2] of] doSomething];
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
  [context check:^{
    [[[expectThat(testObject) receivesAtLeast:2] of] doSomething];
  }];
  
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething at least 2 times but received it only once.", testObject]));
}

- (void)testCanSpecifyExpectationIsCalledAtLeastNumberOfTimesAndPassIfCalledMoreTimes
{
  [context check:^{
    [[[expectThat(testObject) receivesAtLeast:2] of] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanSpecifyExpectationIsCalledAtLeastNumberOfTimesAndPassIfCalledTheExactNumberOfTimes
{
  [context check:^{
    [[[expectThat(testObject) receivesAtLeast:2] of] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

#pragma mark At most (x) times

- (void)testCanSpecifyExpectationIsCalledAtMostNumberOfTimesAndFailIfCalledMoreTimes
{
  [context check:^{
    [[[expectThat(testObject) receivesAtMost:2] of] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, failedWithNumberOfFailures(1));
}

- (void)testCanSpecifyExpectationIsCalledAtMostNumberOfTimesAndPassIfCalledFewerTimes
{
  [context check:^{
    [[[expectThat(testObject) receivesAtMost:2] of] doSomething];
  }];
  
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanSpecifyExpectationIsCalledAtMostNumberOfTimesAndPassIfCalledTheExactNumberOfTimes
{
  [context check:^{
    [[[expectThat(testObject) receivesAtMost:2] of] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

#pragma mark Between (x) and (y) times

- (void)testCanSpecifyExpectationIsCalledBetweenNumberOfTimesAndFailIfCalledMoreTimesThanTheUpperLimit
{
  [context check:^{
    [[[expectThat(testObject) receivesBetween:2 and:5] of] doSomething];
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
  [context check:^{
    [[[expectThat(testObject) receivesBetween:2 and:5] of] doSomething];
  }];
  
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething between 2 and 5 times but received it only once.", testObject]));
}

- (void)testCanSpecifyExpectationIsCalledBetweenNumberOfTimesAndPassIfCalledLowerLimitTimes
{
  [context check:^{
    [[[expectThat(testObject) receivesBetween:2 and:5] of] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanSpecifyExpectationIsCalledBetweenNumberOfTimesAndPassIfCalledUpperLimitTimes
{
  [context check:^{
    [[[expectThat(testObject) receivesBetween:2 and:5] of] doSomething];
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
  [context check:^{
    [[[expectThat(testObject) receivesBetween:2 and:5] of] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

END_TEST_CASE
