//
//  ExampleTests.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "LRMockery.h"
#import "LRTestCase.h"
#import "LRExpectationBuilder.h"

@interface SimpleObject : NSObject
{}
- (void)doSomething;
@end

@implementation SimpleObject; 
- (void)doSomething {}
@end

@interface MockeryTests : SenTestCase
{
  LRMockery *context;
  MockTestCase *testCase;
}
@end

@implementation MockeryTests

- (void)setUp;
{
  testCase = [MockTestCase new];
  context = [LRMockery mockeryForTestCase:testCase];
}

- (void)testCanExpectSingleMethodCallAndPass;
{
  SimpleObject *testObject = [context mock:[SimpleObject class]];
  
  [context checking:^(LRExpectationBuilder *that){
    [[that oneOf:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [context assertSatisfied];
  
  STAssertTrue([testCase numberOfFailures] == 0, 
               @"expected zero failures, got %d.", [testCase numberOfFailures]);
}

- (void)testCanExpectSingleMethodCallAndFail;
{
  SimpleObject *testObject = [context mock:[SimpleObject class]];
  
  [context checking:^(LRExpectationBuilder *that){
    [[that oneOf:testObject] doSomething];
  }];
  
  [context assertSatisfied];
  
  STAssertTrue([testCase numberOfFailures] == 1, 
               @"expected 1 failure, got %d.", [testCase numberOfFailures]);
}

@end
