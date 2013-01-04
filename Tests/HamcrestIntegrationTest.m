//
//  HamcrestIntegrationTest.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "FunctionalMockeryTestCase.h"

DEFINE_FUNCTIONAL_TEST_CASE(HamcrestIntegrationTest)

- (void)testCanExpectInvocationWithEqualObjectAndPass
{
  [context check:^{
    [[expectThat(testObject) receives] doSomethingWithObject:equalTo(@"foo")];
  }];
  
  [testObject doSomethingWithObject:@"foo"];
  
  [context assertSatisfied];

  assertThat(testCase, passed());
}

- (void)testCanExpectInvocationWithEqualObjectAndFail
{
  [context check:^{
    [[expectThat(testObject) receives] doSomethingWithObject:equalTo(@"foo")];
  }];
  
  [testObject doSomethingWithObject:@"bar"];
  
  [context assertSatisfied];
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomethingWithObject: with arguments: [<\"foo\">] once but received it 0 times.", testObject]));
}

- (void)testCanExpectInvocationWithStringWithPrefixAndPass
{
  [context check:^{
    [[expectThat(testObject) receives] doSomethingWithObject:startsWith(@"foo")];
  }];
  
  [testObject doSomethingWithObject:@"foo"];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanExpectInvocationWithStringWithPrefixAndFail
{
  [context check:^{
    [[expectThat(testObject) receives] doSomethingWithObject:startsWith(@"foo")];
  }];
  
  [testObject doSomethingWithObject:@"bar foo"];
  
  [context assertSatisfied];
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
   @"Expected %@ to receive doSomethingWithObject: with arguments: [<a string starting with \"foo\">] once but received it 0 times.", testObject]));
}

- (void)testCanExpectInvocationWithIdenticalObjectAndPass
{
  SimpleObject *dummy = [[SimpleObject alloc] init];

  [context check:^{
    [[expectThat(testObject) receives] doSomethingWithObject:sameInstance(dummy)];
  }];
  
  [testObject doSomethingWithObject:dummy];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanExpectInvocationWithIdenticalObjectAndFail
{
  SimpleObject *dummy = [[SimpleObject alloc] init];

  [context check:^{
    [[expectThat(testObject) receives] doSomethingWithObject:sameInstance(dummy)];
  }];
  
  SimpleObject *other = [[SimpleObject alloc] init];
  [testObject doSomethingWithObject:other];
  
  [context assertSatisfied];
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomethingWithObject: with arguments: [<same instance as 0x%0x %@>] once but received it 0 times.", testObject, dummy, dummy]));
}

END_TEST_CASE
