//
//  LRInvocationToExpectationTranslator.m
//  Mocky
//
//  Created by Luke Redpath on 03/01/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "TestHelper.h"
#import "LRMockObject.h"
#import "LRInvocationToExpectationTranslator.h"

@interface FakeExpectationCapture : NSObject <LRExpectationCapture>

@property (nonatomic, readonly) NSInvocation *capturedInvocation;
@property (nonatomic, readonly) BOOL someDirectMethodCalled;

- (void)someDirectMethod;

@end

@implementation FakeExpectationCapture

- (void)createExpectationFromInvocation:(NSInvocation *)invocation
{
  _capturedInvocation = invocation;
}

- (void)someDirectMethod
{
  _someDirectMethodCalled = YES;
}

@end

DEFINE_TEST_CASE(LRInvocationToExpectationTranslatorTest)

- (void)testTellsTheExpectationCaptureToCreateExpectationsFromInvokedInvocations
{
  FakeExpectationCapture *capture = [[FakeExpectationCapture alloc] init];

  LRInvocationToExpectationTranslator *translator = [[LRInvocationToExpectationTranslator alloc] initWithExpectationCapture:capture];
  
  NSInvocation *invocation = anyValidInvocation();
  [translator invoke:invocation];
  
  STAssertEqualObjects(invocation, capture.capturedInvocation, @"Expected invocation to be captured.");
}

- (void)testItInvokesInvocationsThatCanBeHandledByTheCaptureDirectly
{
  FakeExpectationCapture *capture = [[FakeExpectationCapture alloc] init];
  
  LRInvocationToExpectationTranslator *translator = [[LRInvocationToExpectationTranslator alloc] initWithExpectationCapture:capture];
  
  NSMethodSignature *methodSignature = [capture methodSignatureForSelector:@selector(someDirectMethod)];
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
  invocation.selector = @selector(someDirectMethod);
  
  [translator invoke:invocation];
  
  STAssertNil(capture.capturedInvocation, @"Expected invocation to not be captured.");
  STAssertTrue(capture.someDirectMethodCalled, @"Expected direct method to be called.");
}

END_TEST_CASE
