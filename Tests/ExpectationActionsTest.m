//
//  ExpectationActionsTest.m
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#define LRMOCKY_SHORTHAND
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
  
  [context checking:^(LRExpectationBuilder *that){
    [[that oneOf:testObject] returnSomething]; [that will:returnObject(expectedObject)];
  }];
  
  assertThat([testObject returnSomething], equalTo(expectedObject));
}

- (void)testMocksCanReturnAnObjectFromAnAllowedInvocation;
{
  SimpleObject *testObject = [context mock:[SimpleObject class]];
  
  NSString *expectedObject = @"some string";
  
  [context checking:^(LRExpectationBuilder *that){
    [[that allowing:testObject] returnSomething]; [that will:returnObject(expectedObject)];
  }];
  
  assertThat([testObject returnSomething], equalTo(expectedObject));
}

- (void)testMocksCanCallBlocksFromAnExpectedInvocation;
{
  SimpleObject *testObject = [context mock:[SimpleObject class]];
  
  NSMutableArray *someArray = [NSMutableArray array];
  
  [context checking:^(LRExpectationBuilder *that){
    [[that oneOf:testObject] doSomething]; [that will:performBlock(^(NSInvocation *invocation) {
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
  
  [context checking:^(LRExpectationBuilder *that){
    [[that allowing:testObject] doSomething]; [that will:performBlock(^(NSInvocation *invocation) {
      [someArray addObject: NSStringFromSelector([invocation selector])];
    })];
  }];
  
  [testObject doSomething];
  
  assertThat(someArray, hasItem(@"doSomething"));
}

@end
