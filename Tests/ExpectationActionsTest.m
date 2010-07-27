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
}
@end

@implementation ExpectationActionsTest

- (void)setUp;
{
  testCase = [FakeTestCase new];
  context = [[LRMockery mockeryForTestCase:testCase] retain];
}

- (void)testMocksCanReturnAnObjectFromAnExpectedInvocation;
{
  SimpleObject *testObject = [context mock:[SimpleObject class]];
  
  NSString *expectedObject = @"some string";
  
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) returnSomething]; [it will:returnObject(expectedObject)];
  }];
  
  assertThat([testObject returnSomething], equalTo(expectedObject));
}

- (void)testMocksCanReturnAnObjectFromAnAllowedInvocation;
{
  SimpleObject *testObject = [context mock:[SimpleObject class]];
  
  NSString *expectedObject = @"some string";
  
  [context checking:^(LRExpectationBuilder *builder){
    [allowing(testObject) returnSomething]; [it will:returnObject(expectedObject)];
  }];
  
  assertThat([testObject returnSomething], equalTo(expectedObject));
}

- (void)testMocksCanCallBlocksFromAnExpectedInvocation;
{
  SimpleObject *testObject = [context mock:[SimpleObject class]];
  
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
  SimpleObject *testObject = [context mock:[SimpleObject class]];
  
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
  SimpleObject *testObject = [context mock:[SimpleObject class]];
  
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) returnSomeValue]; [it will:returnInt(10)];
  }];
  
  assertThatInt((int)[testObject returnSomeValue], equalToInt(10));
}

- (void)testMocksCanReturnANonObjectValueFromAnAllowedInvocation;
{
  SimpleObject *testObject = [context mock:[SimpleObject class]];
  
  [context checking:^(LRExpectationBuilder *builder){
    int intValue = 10;
    [allowing(testObject) returnSomeValue]; [it will:returnValue(&intValue)];
  }];
  
  assertThatInt((int)[testObject returnSomeValue], equalToInt(10));
}

@end
