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

@interface Workhorse : NSObject
{}
- (void)doSomething;
@end

@implementation Workhorse; 
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
  Workhorse *workhorse = [context mock:[Workhorse class]];
  
  [context checking:^(LRExpectationBuilder *will){
    [[will expect:workhorse] doSomething];
  }];
  
  [workhorse doSomething];
  [context assertSatisfied];
  
  STAssertTrue([testCase numberOfFailures] == 0, @"expected zero failures, got %d.", [testCase numberOfFailures]);
}

- (void)testCanExpectSingleMethodCallAndFail;
{
  Workhorse *workhorse = [context mock:[Workhorse class]];
  
  [context checking:^(LRExpectationBuilder *will){
    [[will expect:workhorse] doSomething];
  }];
  
  [context assertSatisfied];
  
  STAssertTrue([testCase numberOfFailures] == 1, @"expected 1 failure, got %d.", [testCase numberOfFailures]);
}

@end
