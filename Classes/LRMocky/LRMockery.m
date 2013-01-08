//
//  LRMockery.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRMockery.h"
#import "LRExpectations.h"
#import "LRMockObject.h"
#import "LRUnexpectedInvocation.h"
#import "LRInvocationExpectation.h"
#import "LRNotificationExpectation.h"
#import "LRMockyStateMachine.h"
#import "LRReflectionImposterizer.h"
#import "LRUnexpectedInvocationException.h"
#import "NSInvocation+BlockArguments.h"
#import "NSObject+Identity.h"

#import <OCHamcrest/HCStringDescription.h>

NSString *failureFor(id<HCSelfDescribing> expectation);

@interface LRMockery ()
- (void)assertSatisfiedInFile:(NSString *)fileName lineNumber:(int)lineNumber;
@end

@implementation LRMockery

@synthesize automaticallyResetWhenAsserting;

+ (id)mockeryForTestCase:(id)testCase;
{
  // support SenTestCase out of the box
  return [self mockeryForSenTestCase:(SenTestCase *)testCase];
}

+ (id)mockeryForSenTestCase:(SenTestCase *)testCase;
{
  LRSenTestCaseNotifier *notifier = [LRSenTestCaseNotifier notifierForTestCase:testCase];
  return [[self alloc] initWithNotifier:notifier];
}

- (id)initWithNotifier:(id<LRTestCaseNotifier>)aNotifier;
{
  if (self = [super init]) {
    testNotifier = aNotifier;
    expectations = [[NSMutableArray alloc] init];
    mockObjects  = [[NSMutableArray alloc] init];
    automaticallyResetWhenAsserting = YES;
  }
  return self;
}

#pragma mark - Creating mock objects

- (id)mock:(id)klassOrProtocol;
{
  return [self mock:klassOrProtocol named:[self defaultNameForMockOfType:klassOrProtocol]];
}

- (id)mock:(id)klassOrProtocol named:(NSString *)name
{
  if (![klassOrProtocol LR_isProtocol] && ![klassOrProtocol LR_isClass]) {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Can only mock classes or protocols." userInfo:nil];
  }  
  LRMockObject *mock = [[LRMockObject alloc] initWithInvocationDispatcher:self mockedType:klassOrProtocol name:name];
  [mockObjects addObject:mock];
  return [mock imposterize];
}

- (NSString *)defaultNameForMockOfType:(id)type
{
  NSString *typeName = nil;
  
  if ([type LR_isProtocol]) {
    typeName = NSStringFromProtocol(type);
  }
  else if([type LR_isClass]) {
    typeName = NSStringFromClass(type);
  }
  return [NSString stringWithFormat:@"<mock %@>", typeName];
}

#pragma mark - Configuring expectations

- (void)check:(__weak dispatch_block_t)expectationBlock
{
  [[LRExpectations captureExpectationsWithBlock:expectationBlock] buildExpectations:self];
}

#pragma mark - Notification expectations

- (void)expectNotificationNamed:(NSString *)name;
{
  [self addExpectation:[LRNotificationExpectation expectationWithNotificationName:name]];
}

- (void)expectNotificationNamed:(NSString *)name fromObject:(id)sender;
{
  [self addExpectation:[LRNotificationExpectation expectationWithNotificationName:name sender:sender]];
}

#pragma mark - States

- (LRMockyStateMachine *)states:(NSString *)name;
{
  return [[LRMockyStateMachine alloc] initWithName:name];
}

- (LRMockyStateMachine *)states:(NSString *)name defaultTo:(NSString *)defaultState;
{
  LRMockyStateMachine *stateMachine = [self states:name];
  [stateMachine startsAs:defaultState];
  return stateMachine;
}

NSString *failureFor(id<HCSelfDescribing> expectation) {
  HCStringDescription *description = [HCStringDescription stringDescription];
  [expectation describeTo:description];
  return [description description];
}

#pragma mark - Verification

- (void)assertSatisfied
{
  return [self assertSatisfiedInFile:nil lineNumber:0];
}

- (void)assertSatisfiedInFile:(NSString *)fileName lineNumber:(int)lineNumber;
{
  for (id<LRExpectation> expectation in expectations) {
    if ([expectation isSatisfied] == NO) {
      [testNotifier notifiesFailureWithDescription:failureFor(expectation) inFile:fileName lineNumber:lineNumber];
    }
  }
  if (self.automaticallyResetWhenAsserting) {
    [self reset];
  }
}

#pragma mark -

- (void)addExpectation:(id<LRExpectation>)expectation;
{
  [expectations addObject:expectation];
}

- (void)reset;
{
  [expectations removeAllObjects];
}

#pragma mark - Mock object dispatch

- (void)dispatch:(NSInvocation *)invocation
{
  [invocation retainArguments];
  [invocation copyBlockArguments];
  
  for (id<LRExpectation> expectation in expectations) {
    if ([expectation matches:invocation]) {
      [expectation invoke:invocation];
      return;
    }
  }
  LRUnexpectedInvocation *unexpectedInvocation = [LRUnexpectedInvocation unexpectedInvocation:invocation];
  unexpectedInvocation.mockObject = invocation.target;
  [expectations addObject:unexpectedInvocation];
}

@end

void LRM_assertContextSatisfied(LRMockery *context, NSString *fileName, int lineNumber)
{
  [context assertSatisfiedInFile:fileName lineNumber:lineNumber];
}

