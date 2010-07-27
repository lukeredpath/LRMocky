//
//  ExpectationActionsTest.m
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#define LRMOCKY_SHORTHAND
#define LRMOCKY_SUGAR

#import "TestHelper.h"
#import "LRMocky.h"

@interface ExpectationActionsTest : SenTestCase 
{
  LRMockery *context;
  FakeTestCase *testCase;
  SimpleObject *testObject;
}
@end

@implementation ExpectationActionsTest

- (void)setUp;
{
  testCase = [FakeTestCase new];
  context = [[LRMockery mockeryForTestCase:testCase] retain];
  testObject = [[context mock:[SimpleObject class]] retain];
}

- (void)testMocksCanReturnAnObjectFromAnExpectedInvocation;
{
  NSString *expectedObject = @"some string";
  
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) returnSomething]; [it will:returnObject(expectedObject)];
  }];
  
  assertThat([testObject returnSomething], equalTo(expectedObject));
}

- (void)testMocksCanReturnAnObjectFromAnAllowedInvocation;
{
  NSString *expectedObject = @"some string";
  
  [context checking:^(LRExpectationBuilder *builder){
    [allowing(testObject) returnSomething]; [it will:returnObject(expectedObject)];
  }];
  
  assertThat([testObject returnSomething], equalTo(expectedObject));
}

- (void)testMocksCanCallBlocksFromAnExpectedInvocation;
{
  NSMutableArray *someArray = [NSMutableArray array];
  
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomething]; [it will:performBlock(^(NSInvocation *invocation) {
      [someArray addObject: NSStringFromSelector([invocation selector])];
    })];
  }];
  
  [testObject doSomething];
  
  assertThat(someArray, hasItem(@"doSomething"));
}

- (void)testMocksCanCallBlocksFromAnAllowedInvocation;
{
  NSMutableArray *someArray = [NSMutableArray array];
  
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomething]; [it will:performBlock(^(NSInvocation *invocation) {
      [someArray addObject: NSStringFromSelector([invocation selector])];
    })];
  }];
  
  [testObject doSomething];
  
  assertThat(someArray, hasItem(@"doSomething"));
}

- (void)testMocksCanReturnANonObjectValueFromAnExpectedInvocation;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) returnSomeValue]; [it will:returnInt(10)];
  }];
  
  assertThatInt((int)[testObject returnSomeValue], equalToInt(10));
}

- (void)testMocksCanReturnANonObjectValueFromAnAllowedInvocation;
{
  [context checking:^(LRExpectationBuilder *builder){
    [allowing(testObject) returnSomeValue]; [it will:returnInt(20)];
  }];
  
  assertThatInt((int)[testObject returnSomeValue], equalToInt(20));
}

- (void)testMocksCanReturnDifferentValuesOnConsecutiveCalls;
{
  [context checking:^(LRExpectationBuilder *builder){
    [allowing(testObject) returnSomeValue]; [it will:onConsecutiveCalls(
      returnInt(10),
      returnInt(20),
      returnInt(30),                                       
     nil)];
  }];
  
  assertThatInt((int)[testObject returnSomeValue], equalToInt(10));
  assertThatInt((int)[testObject returnSomeValue], equalToInt(20));
  assertThatInt((int)[testObject returnSomeValue], equalToInt(30));
  assertThatInt((int)[testObject returnSomeValue], equalToInt(30));
}

@end
