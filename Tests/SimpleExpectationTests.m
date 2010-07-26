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

@interface SimpleExpectationTests : SenTestCase
{
  LRMockery *context;
  FakeTestCase *testCase;
}
@end

@implementation SimpleExpectationTests

- (void)setUp;
{
  testCase = [FakeTestCase new];
  context = [[LRMockery mockeryForTestCase:testCase] retain];
}

- (void)testCanExpectSingleMethodCallAndPass;
{
  SimpleObject *testObject = [context mock:[SimpleObject class]];
  
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomething];
  }];
  
  [testObject doSomething];
  [context assertSatisfied];

  assertThat(testCase, passed());
}

- (void)testCanExpectSingleMethodCallAndFail;
{
  SimpleObject *testObject = [context mock:[SimpleObject class]];
  
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomething];
  }];
  
  [context assertSatisfied];
  
  assertThat(testCase, failedWithNumberOfFailures(1));
}

- (void)testFailsWhenUnexpectedMethodIsCalled;
{
  SimpleObject *testObject = [context mock:[SimpleObject class]];
  
  [testObject doSomething];  
  [context assertSatisfied];

  assertThat(testCase, failedWithNumberOfFailures(1));
}

- (void)testCanAllowSingleMethodCellAndPassWhenItIsCalled;
{
  SimpleObject *testObject = [context mock:[SimpleObject class]];
  
  [context checking:^(LRExpectationBuilder *builder){
    [allowing(testObject) doSomething];
  }];
  
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanAllowSingleMethodCellAndPassWhenItIsNotCalled;
{
  SimpleObject *testObject = [context mock:[SimpleObject class]];
  
  [context checking:^(LRExpectationBuilder *builder){
    [allowing(testObject) doSomething];
  }];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

@end
