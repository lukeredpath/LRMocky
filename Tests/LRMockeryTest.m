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

- (void)addAction:(id<LRExpectationAction>)action
{}

- (void)setInvocation:(NSInvocation *)invocation
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

- (void)addAction:(id<LRExpectationAction>)action
{}

- (void)setInvocation:(NSInvocation *)invocation
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
  
  assertThat(testCase, passed());
}

- (void)testTriggersTestFailureForFailingExpectation;
{
  [mockery addExpectation:[[FailingExpectation new] autorelease]];
  [mockery assertSatisfied];
  
  assertThat(testCase, failedWithNumberOfFailures(1));
}

@end
