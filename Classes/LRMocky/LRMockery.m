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
#import "LRMockyStates.h"
#import "LRReflectionImposterizer.h"
#import "LRUnexpectedInvocationException.h"
#import "NSInvocation+LRAdditions.h"

#import <OCHamcrest/HCStringDescription.h>

NSString *failureFor(id<HCSelfDescribing> expectation);

@interface LRMockery ()
- (void)assertSatisfiedInFile:(NSString *)fileName lineNumber:(int)lineNumber;
@end

@implementation LRMockery {
  id<LRImposterizer> _imposterizer;
}

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

    _imposterizer = [[LRReflectionImposterizer alloc] init];
  }
  return self;
}

#pragma mark - Creating mock objects

- (id)mock:(Class)klass;
{
  LRMockObject *mock = [[LRMockObject alloc] initWithInvocationDispatcher:self mockedType:klass name:nil];
  [mockObjects addObject:mock];
  return [_imposterizer imposterizeClass:klass invokable:mock ancilliaryProtocols:@[@protocol(LRCaptureControl)]];
}

- (id)mock:(Class)klass named:(NSString *)name;
{
  LRMockObject *mock = [[LRMockObject alloc] initWithInvocationDispatcher:self mockedType:klass name:name];
  [mockObjects addObject:mock];
  return [_imposterizer imposterizeClass:klass invokable:mock ancilliaryProtocols:@[@protocol(LRCaptureControl)]];
}

- (id)mock
{
  return [self mock:[NSObject class]];
}

- (id)mockNamed:(NSString *)name
{
  return [self mock:[NSObject class] named:name];
}

- (id)protocolMock:(Protocol *)protocol;
{
  LRMockObject *mock = [[LRMockObject alloc] initWithInvocationDispatcher:self mockedType:protocol name:nil];
  [mockObjects addObject:mock];
  return [_imposterizer imposterizeProtocol:protocol invokable:mock ancilliaryProtocols:@[@protocol(LRCaptureControl)]];
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

