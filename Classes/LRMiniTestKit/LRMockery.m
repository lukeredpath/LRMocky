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

@implementation LRMockery

+ (id)mockeryForSenTestCase:(SenTestCase *)testCase;
{
  return [self mockeryForTestCase:[LRSenTestCaseAdapter adapt:testCase]];
}

+ (id)mockeryForTestCase:(id<LRTestCase>)testCase;
{
  return [[[self alloc] initWithTestCase:testCase] autorelease];
}

- (id)initWithTestCase:(id<LRTestCase>)aTestCase;
{
  if (self = [super init]) {
    testCase = [aTestCase retain];
    expectations = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc;
{
  [testCase release];
  [expectations release];
  [super dealloc];
}

- (id)mock:(Class)klass;
{
  return [LRMockObject mockForClass:klass inContext:self]; 
}

- (void)checking:(void (^)(id will))expectationBlock;
{
  expectationBlock([LRExpectationBuilder builderInContext:self]);
}

- (void)assertSatisfied;
{
  for (id<LRExpectation> expectation in expectations) {
    if ([expectation isSatisfied] == NO) {
      [testCase failWithException:[expectation failureException]];
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
}

@end
