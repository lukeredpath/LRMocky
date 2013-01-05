//
//  LRInvocationExpectationTest.m
//  Mocky
//
//  Created by Luke Redpath on 04/01/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "TestHelper.h"
#import "HCBlockMatcher.h"
#import "LRInvocationExpectation.h"
#import "LRAllParametersMatcher.h"

id anyObject(void) {
  return [[SimpleObject alloc] init];
}

NSInvocation *invocationForSelectorOn(id object, SEL selector) {
  NSMethodSignature *methodSignature = [object methodSignatureForSelector:selector];
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
  invocation.target = object;
  invocation.selector = selector;
  return invocation;
}

NSInvocation *anyInvocationOn(id object) {
  return invocationForSelectorOn(object, @selector(description));
}

DEFINE_TEST_CASE(LRInvocationExpectationTest)

- (void)testMatchesAnyInvocationByDefault
{
  LRInvocationExpectation *expectation = [[LRInvocationExpectation alloc] init];
  
  assertTrue([expectation matches:anyInvocationOn(anyObject())]);
}

- (void)testCanConstrainToInvocationsOnSpecificTarget
{
  id targetObject = anyObject();
  
  LRInvocationExpectation *expectation = [[LRInvocationExpectation alloc] init];
  expectation.target = targetObject;
  
  assertTrue([expectation matches:anyInvocationOn(targetObject)]);
  assertFalse([expectation matches:anyInvocationOn(anyObject())]);
}

- (void)testCanConstrainToInvocationsOnSpecificSelector
{
  SEL expectedSelector = @selector(description);
  
  LRInvocationExpectation *expectation = [[LRInvocationExpectation alloc] init];
  expectation.selector = expectedSelector;
  
  assertTrue([expectation matches:invocationForSelectorOn(anyObject(), expectedSelector)]);
  assertFalse([expectation matches:invocationForSelectorOn(anyObject(), @selector(init))]);
}

- (void)testCanConstrainToInvocationsWithSpecificParameters
{
  NSInvocation *_invocation = invocationForSelectorOn(anyObject(), @selector(doSomethingWithObject:));
  
  LRInvocationExpectation *expectation = [[LRInvocationExpectation alloc] init];
  
  id<HCMatcher> parametersMatcher = [[LRAllParametersMatcher alloc] initWithParameters:@[@"expected"]];
  expectation.parametersMatcher = parametersMatcher;
  
  id argument;
  
  argument = @"expected";
  [_invocation setArgument:&argument atIndex:2];
  
  assertTrue([expectation matches:_invocation]);
  
  argument = @"unexpected";
  [_invocation setArgument:&argument atIndex:2];
  
  assertFalse([expectation matches:_invocation]);
}

// TODO: move these tests somewhere better
//
//- (void)testCanConstrainToInvocationsWithNonObjectArguments
//{
//  NSInvocation *_invocation = invocationForSelectorOn(anyObject(), @selector(doSomethingWithInt:));
//  
//  LRInvocationExpectation *expectation = [[LRInvocationExpectation alloc] init];
//  
//  id<HCMatcher> parametersMatcher = [[AllParametersMatcher alloc] initWithParameters:@[@123]];
//  expectation.parametersMatcher = parametersMatcher;
//  
//  NSInteger argument;
//  
//  argument = 123;
//  [_invocation setArgument:&argument atIndex:2];
//  
//  assertTrue([expectation matches:_invocation]);
//  
//  argument = 456;
//  [_invocation setArgument:&argument atIndex:2];
//  
//  assertFalse([expectation matches:_invocation]);
//}
//
//- (void)testCanConstrainObjectArgumentsUsingMatchers
//{
//  NSInvocation *_invocation = invocationForSelectorOn(anyObject(), @selector(doSomethingWithObject:));
//  
//  LRInvocationExpectation *expectation = [[LRInvocationExpectation alloc] init];
//  
//  id<HCMatcher> parametersMatcher = [[AllParametersMatcher alloc] initWithParameters:@[startsWith(@"exp")]];
//  expectation.parametersMatcher = parametersMatcher;
//  
//  id argument;
//  
//  argument = @"expected";
//  [_invocation setArgument:&argument atIndex:2];
//  
//  assertTrue([expectation matches:_invocation]);
//  
//  argument = @"unexpected";
//  [_invocation setArgument:&argument atIndex:2];
//  
//  assertFalse([expectation matches:_invocation]);
//}

END_TEST_CASE
