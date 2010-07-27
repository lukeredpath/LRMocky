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
  
  assertThat(testCase, failedWithNumberOfFailures(1));
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

@end
