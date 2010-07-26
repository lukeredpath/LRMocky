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

@implementation FakeTestCase

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

- (void)failWithException:(NSException *)exception
{
  [failures addObject:exception];
}

- (NSUInteger)numberOfFailures;
{
  return [failures count];
}

- (NSNumber *)numberOfFailuresAsNumber;
{
  return [NSNumber numberWithInt:[self numberOfFailures]];
}

- (NSString *)description;
{
  return [NSString stringWithFormat:@"MockTestCase with %d failures", [self numberOfFailures]];
}

@end

@implementation SimpleObject; 
- (void)doSomething {}
- (id)returnSomething { return nil; }
@end

#pragma mark Custom assertions and matchers

id<HCMatcher> passed()
{
  id<HCMatcher> valueMatcher = [HCIsEqual isEqualTo:[NSNumber numberWithInt:0]];
  NSInvocation *invocation   = [HCInvocationMatcher createInvocationForSelector:@selector(numberOfFailuresAsNumber) onClass:[FakeTestCase class]];
  return [[[HCInvocationMatcher alloc] initWithInvocation:invocation matching:valueMatcher] autorelease];
}

id<HCMatcher> failedWithNumberOfFailures(int numberOfFailures)
{
  id<HCMatcher> valueMatcher = [HCIsEqual isEqualTo:[NSNumber numberWithInt:numberOfFailures]];
  NSInvocation *invocation   = [HCInvocationMatcher createInvocationForSelector:@selector(numberOfFailuresAsNumber) onClass:[FakeTestCase class]];
  return [[[HCInvocationMatcher alloc] initWithInvocation:invocation matching:valueMatcher] autorelease];
}

