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
#import "OLD_LRMockObject.h"
#import "LRUnexpectedInvocation.h"
#import "LRInvocationExpectation.h"
#import "LRNotificationExpectation.h"
#import "LRMockyStates.h"
#import "LRExpectationMessage.h"
#import "LRReflectionImposterizer.h"

#define addMock(mock) [self addAndReturnMock:mock];

NSString *failureFor(id<LRDescribable> expectation);

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
  return [[[self alloc] initWithNotifier:notifier] autorelease];
}

- (id)initWithNotifier:(id<LRTestCaseNotifier>)aNotifier;
{
  if (self = [super init]) {
    testNotifier = [aNotifier retain];
    expectations = [[NSMutableArray alloc] init];
    mockObjects  = [[NSMutableArray alloc] init];
    automaticallyResetWhenAsserting = YES;

    _imposterizer = [[LRReflectionImposterizer alloc] init];
  }
  return self;
}

- (void)dealloc;
{
  for (OLD_LRMockObject *mock in mockObjects) {
    [mock undoSideEffects];
  }
  [mockObjects release];
  [testNotifier release];
  [expectations release];
  [super dealloc];
}

- (id)addAndReturnMock:(id)mock
{
  [mockObjects addObject:mock];
  return mock;
}

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

#pragma mark - Creating mock objects

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

- (id)partialMockForObject:(id)object
{
  return addMock([OLD_LRMockObject partialMockForObject:object inContext:self]);
}

#pragma mark -

- (void)expectNotificationNamed:(NSString *)name;
{
  [self addExpectation:[LRNotificationExpectation expectationWithNotificationName:name]];
}

- (void)expectNotificationNamed:(NSString *)name fromObject:(id)sender;
{
  [self addExpectation:[LRNotificationExpectation expectationWithNotificationName:name sender:sender]];
}

- (LRMockyStateMachine *)states:(NSString *)name;
{
  return [[[LRMockyStateMachine alloc] initWithName:name] autorelease];
}

- (LRMockyStateMachine *)states:(NSString *)name defaultTo:(NSString *)defaultState;
{
  LRMockyStateMachine *stateMachine = [self states:name];
  [stateMachine startsAs:defaultState];
  return stateMachine;
}

- (void)setExpectations:(__weak dispatch_block_t)expectationBlock
{
  [LRExpectationBuilder buildExpectationsWithBlock:expectationBlock inContext:self];
}

- (void)check:(__weak dispatch_block_t)expectationBlock
{
  [LRExpectationBuilder buildExpectationsWithBlock:expectationBlock inContext:self];
}

NSString *failureFor(id<LRDescribable> expectation) {
  LRExpectationMessage *errorMessage = [[[LRExpectationMessage alloc] init] autorelease];
  [expectation describeTo:errorMessage];
  return [errorMessage description];
}

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
  for (id<LRExpectation> expectation in expectations) {
    if ([expectation matches:invocation]) {
      [expectation invoke:invocation];
    }
  }
//  LRUnexpectedInvocation *unexpectedInvocation = [LRUnexpectedInvocation unexpectedInvocation:invocation];
//  unexpectedInvocation.mockObject = mockObject;
//  [expectations addObject:unexpectedInvocation];
  
  // TODO: throw unexpected invocation error
}

@end

void LRM_assertContextSatisfied(LRMockery *context, NSString *fileName, int lineNumber)
{
  [context assertSatisfiedInFile:fileName lineNumber:lineNumber];
}

