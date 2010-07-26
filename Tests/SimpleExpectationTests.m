//
//  ExampleTests.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "LRMocky.h"

@interface SimpleExpectationTests : SenTestCase
{
  LRMockery *context;
  MockTestCase *testCase;
}
@end

@implementation SimpleExpectationTests

- (void)setUp;
{
  testCase = [MockTestCase new];
  context = [[LRMockery mockeryForTestCase:testCase] retain];
}

- (void)testCanExpectSingleMethodCallAndPass;
{
  SimpleObject *testObject = [context mock:[SimpleObject class]];
  
  [context checking:^(LRExpectationBuilder *that){
    [[that oneOf:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [context assertSatisfied];

  assertThat(testCase, passed());
}

- (void)testCanExpectSingleMethodCallAndFail;
{
  SimpleObject *testObject = [context mock:[SimpleObject class]];
  
  [context checking:^(LRExpectationBuilder *that){
    [[that oneOf:testObject] doSomething];
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
  
  [context checking:^(LRExpectationBuilder *that){
    [[that allowing:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanAllowSingleMethodCellAndPassWhenItIsNotCalled;
{
  SimpleObject *testObject = [context mock:[SimpleObject class]];
  
  [context checking:^(LRExpectationBuilder *that){
    [[that allowing:testObject] doSomething];
  }];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

@end
