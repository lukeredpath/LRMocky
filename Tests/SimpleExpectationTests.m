//
//  ExampleTests.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "FunctionalMockeryTestCase.h"

@interface SimpleExpectationTests : FunctionalMockeryTestCase
{}
@end

@implementation SimpleExpectationTests

- (void)testCanExpectSingleMethodCallAndPass;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomething];
  }];
  
  [testObject doSomething];
  [context assertSatisfied];

  assertThat(testCase, passed());
}

- (void)testCanExpectSingleMethodCallAndFail;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomething];
  }];
  
  [context assertSatisfied];
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething exactly(1) times but received it 0 times", testObject]));
}

- (void)testFailsWhenUnexpectedMethodIsCalled;
{
  [testObject doSomething];  
  [context assertSatisfied];

  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Unexpected method doSomething called on %@", testObject]));
}

- (void)testCanAllowSingleMethodCellAndPassWhenItIsCalled;
{
  [context checking:^(LRExpectationBuilder *builder){
    [allowing(testObject) doSomething];
  }];
  
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanAllowSingleMethodCellAndPassWhenItIsNotCalled;
{
  [context checking:^(LRExpectationBuilder *builder){
    [allowing(testObject) doSomething];
  }];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanExpectMethodCallWithSpecificParametersAndPassWhenTheCorrectParameterIsUsed;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) returnSomethingForValue:@"one"];
  }];
  
  [testObject returnSomethingForValue:@"one"];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanExpectMethodCallWithSpecificParametersAndFailWhenTheWrongParameterIsUsed;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) returnSomethingForValue:@"one"];
  }];
  
  [testObject returnSomethingForValue:@"two"];
  [context assertSatisfied];
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive returnSomethingForValue: with(@\"one\") exactly(1) times but received it 0 times. returnSomethingForValue: was called with(@\"two\").", testObject]));
}

- (void)testCanExpectMethodCallWithSpecificParametersAndFailWhenAtLeastOneParameterIsWrong;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomethingWith:@"foo" andObject:@"bar"];
  }];
  
  [testObject doSomethingWith:@"foo" andObject:@"qux"];
  [context assertSatisfied];
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomethingWith:andObject: with(@\"foo\", @\"bar\") exactly(1) times but received it 0 times. doSomethingWith:andObject: was called with(@\"foo\", @\"qux\").", testObject]));
}

- (void)testCanExpectMethodCallWithSpecificNonObjectParametersAndPass;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomethingWithInt:20];
  }];
  
  [testObject doSomethingWithInt:20];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanExpectMethodCallWithSpecificNonObjectParametersAndFail;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomethingWithInt:10];
  }];
  
  [testObject doSomethingWithInt:20];
  [context assertSatisfied];

  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomethingWithInt: with(10) exactly(1) times but received it 0 times. doSomethingWithInt: was called with(20).", testObject]));
}

@end
