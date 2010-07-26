//
//  TestHelper.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"

@implementation NSInvocation (LRAdditions)

+ (NSInvocation *)invocationForSelector:(SEL)selector onClass:(Class)aClass;
{
  NSMethodSignature *signature = [aClass instanceMethodSignatureForSelector:selector];
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
  [invocation setSelector:selector];
  return invocation;
}

@end

@implementation MockTestCase

- (id)init
{
  if (self = [super init]) {
    failures = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc;
{
  [failures release];
  [super dealloc];
}

- (void)failWithException:(NSException *)anException;
{
  [failures addObject:anException];
}

- (NSUInteger)numberOfFailures;
{
  return [failures count];
}

@end

@implementation SimpleObject; 
- (void)doSomething {}
- (id)returnSomething { return nil; }
@end

#pragma mark Custom assertions

void assertThatTestCasePassed(MockTestCase *mockTestCase, SenTestCase *testCase) {
  id self = testCase;
  STAssertTrue([mockTestCase numberOfFailures] == 0, 
               @"expected zero failures, got %d.", [mockTestCase numberOfFailures]);
}

void assertThatTestCaseFailedWithFailures(MockTestCase * mockTestCase, int numberOfFailures, SenTestCase *testCase) {
  id self = testCase;
  STAssertTrue([mockTestCase numberOfFailures] == numberOfFailures, 
               @"expected %d failure(s), got %d.", numberOfFailures, [mockTestCase numberOfFailures]);
  
}
