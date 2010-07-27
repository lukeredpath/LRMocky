//
//  ExampleTests.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#define LRMOCKY_SHORTHAND
#define LRMOCKY_SUGAR

#import "TestHelper.h"
#import "LRMocky.h"
#import "FunctionalMockeryTestCase.h"

@interface SimpleExpectationTests : FunctionalMockeryTestCase
{}
@end

@implementation SimpleExpectationTests

- (void)testCanExpectSingleMethodCallAndPass;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomething];
  }];
  
  [testObject doSomething];
  [context assertSatisfied];

  assertThat(testCase, passed());
}

- (void)testCanExpectSingleMethodCallAndFail;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomething];
  }];
  
  [context assertSatisfied];
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething exactly(1) times but received it 0 times", testObject]));
}

- (void)testFailsWhenUnexpectedMethodIsCalled;
{
  [testObject doSomething];  
  [context assertSatisfied];

  assertThat(testCase, failedWithNumberOfFailures(1));
}

- (void)testCanAllowSingleMethodCellAndPassWhenItIsCalled;
{
  [context checking:^(LRExpectationBuilder *builder){
    [allowing(testObject) doSomething];
  }];
  
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanAllowSingleMethodCellAndPassWhenItIsNotCalled;
{
  [context checking:^(LRExpectationBuilder *builder){
    [allowing(testObject) doSomething];
  }];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanExpectMethodCallWithSpecificParametersAndPassWhenTheCorrectParameterIsUsed;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) returnSomethingForValue:@"one"];
  }];
  
  [testObject returnSomethingForValue:@"one"];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanExpectMethodCallWithSpecificParametersAndFailWhenTheWrongParameterIsUsed;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) returnSomethingForValue:@"one"];
  }];
  
  [testObject returnSomethingForValue:@"two"];
  [context assertSatisfied];
  
  assertThat(testCase, failedWithNumberOfFailures(1));
}

- (void)testCanExpectMethodCallWithSpecificParametersAndFailWhenAtLeastOneParameterIsWrong;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomethingWith:@"foo" andObject:@"bar"];
  }];
  
  [testObject doSomethingWith:@"foo" andObject:@"qux"];
  [context assertSatisfied];
  
  assertThat(testCase, failedWithNumberOfFailures(1));
}

- (void)testCanExpectMethodCallWithSpecificNonObjectParametersAndPass;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomethingWithInt:20];
  }];
  
  [testObject doSomethingWithInt:20];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanExpectMethodCallWithSpecificNonObjectParametersAndFail;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomethingWithInt:10];
  }];
  
  [testObject doSomethingWithInt:20];
  [context assertSatisfied];

  assertThat(testCase, failedWithNumberOfFailures(1));
}

@end
