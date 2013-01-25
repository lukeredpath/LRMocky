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

@synthesize action = _action;
@synthesize statePredicate = _statePredicate;

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

- (void)describeTo:(id<HCDescription>)description
{}

@end

@interface PassingExpectation : NSObject <LRExpectation>
{}
@end

@implementation PassingExpectation

@synthesize action = _action;
@synthesize statePredicate = _statePredicate;

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

- (void)describeTo:(id<HCDescription>)description
{}

@end

DEFINE_TEST_CASE(LRMockeryTest) {
  FakeTestCase *testCase;
  LRMockery *mockery;
}


- (void)setUp;
{
  testCase = [[FakeTestCase alloc] init];
  mockery = [LRMockery mockeryForTestCase:testCase];
}

#pragma mark -
#pragma mark LRMockery tests

- (void)testNotifiesNoFailuresWhenAllExpectationsPass;
{
  [mockery addExpectation:[PassingExpectation new]];
  [mockery assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testNotifiesFailureForFailingExpectation;
{
  [mockery addExpectation:[FailingExpectation new]];
  [mockery assertSatisfied];
  
  assertThat(testCase, failedWithNumberOfFailures(1));
}

END_TEST_CASE
