//
//  HamcrestIntegrationTest.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#define LRMOCKY_SHORTHAND
#define LRMOCKY_SUGAR

#import "TestHelper.h"
#import "LRMocky.h"
#import "FunctionalMockeryTestCase.h"

@interface HamcrestIntegrationTest : FunctionalMockeryTestCase 
{}
@end

@implementation HamcrestIntegrationTest

- (void)testCanExpectInvocationWithEqualObjectAndPass
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomethingWithObject:with(equalTo(@"foo"))];
  }];
  
  [testObject doSomethingWithObject:@"foo"];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanExpectInvocationWithEqualObjectAndFail
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomethingWithObject:with(equalTo(@"foo"))];
  }];
  
  [testObject doSomethingWithObject:@"bar"];
  [context assertSatisfied];
  
  assertThat(testCase, failedWithNumberOfFailures(1));
}

- (void)testCanExpectInvocationWithIdenticalObjectAndPass
{
  SimpleObject *dummy = [[SimpleObject alloc] init];

  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomethingWithObject:with(sameInstance(dummy))];
  }];
  
  [testObject doSomethingWithObject:dummy];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanExpectInvocationWithIdenticalObjectAndFail
{
  SimpleObject *dummy = [[SimpleObject alloc] init];

  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomethingWithObject:with(sameInstance(dummy))];
  }];
  
  [testObject doSomethingWithObject:[[[SimpleObject alloc] init] autorelease]];
  [context assertSatisfied];
  
  assertThat(testCase, failedWithNumberOfFailures(1));
}

@end
