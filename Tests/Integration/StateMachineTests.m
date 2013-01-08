//
//  StateMachineTests.m
//  Mocky
//
//  Created by Luke Redpath on 30/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "FunctionalMockeryTestCase.h"

@protocol ToMakeTestCompile <NSObject>

- (void)becomes:(NSString *)state;
- (void)equals:(NSString *)state;

@end

DEFINE_FUNCTIONAL_TEST_CASE(StateMachineTests) {
  LRMockyStateMachine *readiness;
}

- (void)setUp
{
  [super setUp];
  
  readiness = [context states:@"readiness"];
}

- (void)testCanConstrainExpectationsToOccurWithinGivenState
{
  [readiness startsAs:@"unready"];
  
  [context check:^{
    whenState([readiness equals:@"ready"], ^{
      [[expectThat(testObject) receives] doSomething];
    });
  }];
  
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, failedWithNumberOfFailures(2));
}

- (void)testAllowsExpectationsToOccurWhenAlreadyInCorrectState
{
  [readiness startsAs:@"ready"];
  
  [context check:^{
    whenState([readiness equals:@"ready"], ^{
      [[expectThat(testObject) receives] doSomething];
    });
  }];
  
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanTriggerStateChangesAsResultOfExpectation
{
  [readiness startsAs:@"unready"];
  
  [context check:^{
    [allowing(testObject) doSomething]; [then state:readiness becomes:@"ready"];
  }];
  
  [testObject doSomething];
  
  assertThat(readiness.currentState, equalTo(@"ready"));
  assertThat(testCase, passed());
}

- (void)testMultipleExpectationsWithStates
{
  [readiness startsAs:@"unready"];
  
  [context check:^{
    [allowing(testObject) doSomething]; [then state:readiness becomes:@"ready"];
    
    whenState([readiness equals:@"ready"], ^{
      [[expectThat(testObject) receives] doSomethingElse];
    });
  }];
  
  [testObject doSomething];
  [testObject doSomethingElse];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

END_TEST_CASE
