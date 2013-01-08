//
//  ExpectationsWithDifferentArguments.m
//  Mocky
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "FunctionalMockeryTestCase.h"

DEFINE_FUNCTIONAL_TEST_CASE(ExpectationsWithDifferentArguments)

- (void)testCanExpectTheSameMethodWithDifferentArguments
{
  [context check:^{
    [[expectThat(testObject) receives] doSomethingWithObject:@"foo"];
    [[expectThat(testObject) receives] doSomethingWithObject:@"bar"];
  }];
  
  [testObject doSomethingWithObject:@"foo"];
  [testObject doSomethingWithObject:@"bar"];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanExpectTheSameMethodWithDifferentArgumentsUsingMatchers
{
  [context check:^{
    [[expectThat(testObject) receives] doSomethingWithObject:equalTo(@"foo")];
    [[expectThat(testObject) receives] doSomethingWithObject:equalTo(@"bar")];
  }];
  
  [testObject doSomethingWithObject:@"foo"];
  [testObject doSomethingWithObject:@"bar"];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

END_TEST_CASE
