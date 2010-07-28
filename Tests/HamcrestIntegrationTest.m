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
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomethingWithObject: with(\"foo\") exactly(1) times but received it 0 times. doSomethingWithObject: was called with(@\"bar\").", testObject]));
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
  
  SimpleObject *other = [[[SimpleObject alloc] init] autorelease];
  [testObject doSomethingWithObject:other];
  [context assertSatisfied];
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomethingWithObject: with(sameInstance(<%@>)) exactly(1) times but received it 0 times. doSomethingWithObject: was called with(%@).", testObject, dummy, other]));
}

@end
