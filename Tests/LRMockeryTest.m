//
//  LRMockeryTest.m
//  Mocky
//
//  Created by Luke Redpath on 22/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "LRExpectation.h"
#import "LRMockery.h"

@interface FailingExpectation : NSObject <LRExpectation>
{}
@end

@implementation FailingExpectation

- (BOOL)isSatisfied
{
  return NO;
}

- (NSException *)failureException;
{
  return [NSException exceptionWithName:@"FailingExpectation" reason:@"always fails" userInfo:nil];
}

- (BOOL)matches:(NSInvocation *)invocation;
{
  return YES;
}

- (void)invoke:(NSInvocation *)invocation;
{}

@end

@interface PassingExpectation : NSObject <LRExpectation>
{}
@end

@implementation PassingExpectation

- (BOOL)isSatisfied;
{
  return YES;
}

- (NSException *)failureException;
{
  return nil;
}

- (BOOL)matches:(NSInvocation *)invocation;
{
  return YES;
}

- (void)invoke:(NSInvocation *)invocation;
{}

@end

@interface LRMockeryTest : SenTestCase 
{
  MockTestCase *testCase;
  LRMockery *mockery;
}
@end

@implementation LRMockeryTest

- (void)setUp;
{
  testCase = [[MockTestCase alloc] init];
  mockery = [[LRMockery alloc] initWithTestCase:testCase];
}

#pragma mark -
#pragma mark LRMockery tests

- (void)testTriggersNoTestFailuresWhenAllExpectationsPass;
{
  [mockery addExpectation:[[PassingExpectation new] autorelease]];
  [mockery assertSatisfied];
  
  STAssertTrue([testCase numberOfFailures] == 0, @"Expected 0 failures, got %d.", [testCase numberOfFailures]);
}

- (void)testTriggersTestFailureForFailingExpectation;
{
  [mockery addExpectation:[[FailingExpectation new] autorelease]];
  [mockery assertSatisfied];
  
  STAssertTrue([testCase numberOfFailures] == 1, @"Expected 1 failure, got %d.", [testCase numberOfFailures]);
}

@end
