//
//  LRMockObjectTest.m
//  Mocky
//
//  Created by Luke Redpath on 03/01/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "TestHelper.h"
#import "LRMockObject.h"

@interface FakeDispatcher : NSObject <LRInvocationDispatcher>

@property (nonatomic, readonly) NSInvocation *lastDispatched;

@end

@implementation FakeDispatcher {
  NSMutableArray *_invocationsReceived;
}

- (id)init {
  if ((self = [super init])) {
    _invocationsReceived = [[NSMutableArray alloc] init];
  }
  return self;
}

- (NSInvocation *)lastDispatched
{
  return [_invocationsReceived lastObject];
}

- (void)dispatch:(NSInvocation *)invocation
{
  [_invocationsReceived addObject:invocation];
}

@end

DEFINE_TEST_CASE(LRMockObjectTest) {
  FakeDispatcher<LRInvocationDispatcher> *dispatcher;
}

- (void)setUp
{
  dispatcher = [[FakeDispatcher alloc] init];
}

- (void)testForwardsInvocationsToDispatcher
{
  LRMockObject *mockObject = [[LRMockObject alloc] initWithInvocationDispatcher:dispatcher mockedType:NSObject.class name:nil];
  NSInvocation *invocation = anyValidInvocation();

  [mockObject invoke:invocation];
  
  assertThat(dispatcher.lastDispatched, equalTo(invocation));
}

- (void)testDoesntForwardInvocationsOfCaptureControlProtocolMethodsButHandlesThemDirectly
{
  /* Because LRMockObject instances will ultimately be wrapped in an invocation intercepting
   proxy (see LRImposter), all calls to methods on the mock will ultimately be dispatched through
   it's invoke: method, including methods it implements directly.*/

  LRMockObject *mockObject = [[LRMockObject alloc] initWithInvocationDispatcher:dispatcher mockedType:NSObject.class name:nil];
  
  SEL selectorForMethodNotToForward = @selector(captureExpectationTo:);

  NSMethodSignature *methodSignature = [mockObject methodSignatureForSelector:selectorForMethodNotToForward];

  NSInvocation *protocolInvocation = [NSInvocation invocationWithMethodSignature:methodSignature];
  [protocolInvocation setSelector:selectorForMethodNotToForward];
  
  [mockObject invoke:protocolInvocation];
  
  assertNil(dispatcher.lastDispatched);
}

- (void)testCanHaveDescriptiveName
{
  LRMockObject *mockObject = [[LRMockObject alloc] initWithInvocationDispatcher:dispatcher mockedType:NSObject.class name:@"Test Name"];
  
  assertThat(mockObject.name, equalTo(@"Test Name"));
}

END_TEST_CASE
