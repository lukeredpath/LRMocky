//
//  LRMockery.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRMockery.h"
#import "LRExpectationBuilder.h"
#import "LRMockObject.h"
#import "LRUnexpectedInvocation.h"

@implementation LRMockery

+ (id)mockeryForTestCase:(id)testCase;
{
  // support SenTestCase out of the box
  return [self mockeryForSenTestCase:(SenTestCase *)testCase];
}

+ (id)mockeryForSenTestCase:(SenTestCase *)testCase;
{
  LRSenTestCaseNotifier *notifier = [LRSenTestCaseNotifier notifierForTestCase:testCase];
  return [[[self alloc] initWithNotifier:notifier] autorelease];
}

- (id)initWithNotifier:(id<LRTestCaseNotifier>)aNotifier;
{
  if (self = [super init]) {
    testNotifier = [aNotifier retain];
    expectations = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc;
{
  [testNotifier release];
  [expectations release];
  [super dealloc];
}

- (id)mock:(Class)klass;
{
  return [LRMockObject mockForClass:klass inContext:self]; 
}

- (id)mock:(Class)klass named:(NSString *)name;
{
  LRMockObject *mock = [self mock:klass];
  mock.name = name;
  return mock;
}

- (void)checking:(void (^)(id will))expectationBlock;
{
  expectationBlock([LRExpectationBuilder builderInContext:self]);
}

- (void)assertSatisfied;
{
  for (id<LRExpectation> expectation in expectations) {
    if ([expectation isSatisfied] == NO) {
      [testNotifier notifiesFailureWithException:[expectation failureException]];
    }
  }
}

- (void)addExpectation:(id<LRExpectation>)expectation;
{
  [expectations addObject:expectation];
}

- (void)dispatchInvocation:(NSInvocation *)invocation;
{
  for (id<LRExpectation> expectation in expectations) {
    if ([expectation matches:invocation]) {
      return [expectation invoke:invocation];
    }
  }
  LRUnexpectedInvocation *unexpectedInvocation = [LRUnexpectedInvocation unexpectedInvocation:invocation];
  unexpectedInvocation.mockObject = [invocation target];
  [expectations addObject:unexpectedInvocation];
}

@end
