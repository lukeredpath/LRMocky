//
//  LRImposterTest.m
//  Mocky
//
//  Created by Luke Redpath on 03/01/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "TestHelper.h"
#import "LRReflectionImposterizer.h"

@protocol TestProtocol
- (void)doSomethingElse;
@optional
- (void)doSomethingOptional;
@end

@protocol ExtendedTestProtocol <TestProtocol>
@end

@interface TestClass : NSObject
- (void)doSomething;
@end

@implementation TestClass
- (void)doSomething {}
@end

@interface CapturesInvocations : NSObject <LRInvokable>
@property (nonatomic, readonly) NSArray *capturedInvocations;
@end

@implementation CapturesInvocations {
  NSMutableArray *_capturedInvocations;
}

@synthesize capturedInvocations = _capturedInvocations;

- (id)init
{
  self = [super init];
  if (self) {
    _capturedInvocations = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)invoke:(NSInvocation *)invocation
{
  [_capturedInvocations addObject:invocation];
}

@end

DEFINE_TEST_CASE(LRReflectionImposterizerTest) {
  LRReflectionImposterizer *imposterizer;
  CapturesInvocations *invocationCapturer;
}

- (void)setUp
{
  imposterizer = [[LRReflectionImposterizer alloc] init];
  invocationCapturer = [[CapturesInvocations alloc] init];
}

- (void)testImposterizedClassesForwardInvocationsToInvokableForValidInstanceMethods
{
  TestClass *imposter = [imposterizer imposterizeClass:TestClass.class invokable:invocationCapturer ancilliaryProtocols:nil];
  
  [imposter doSomething];
  
  NSInvocation *lastInvocation = [invocationCapturer.capturedInvocations lastObject];
  STAssertNotNil(lastInvocation, @"Expected forwarded invocation to be captured");
}

- (void)testImposterizedClassesRaiseForUnknownInstanceMethods
{
  id imposter = [imposterizer imposterizeClass:TestClass.class invokable:invocationCapturer ancilliaryProtocols:nil];
  STAssertThrows([imposter string], @"Expected unknown method to raise exception");
}

- (void)testImposterizedClassesReportTheyRespondToAnyValidClassInstanceMethods
{
  TestClass *imposter = [imposterizer imposterizeClass:TestClass.class invokable:invocationCapturer ancilliaryProtocols:nil];
  
  STAssertTrue([imposter respondsToSelector:@selector(doSomething)], @"Expected to report responds to selector.");
}

- (void)testImposterizedClassesReportTheyConformToAnyInheritedProtocols
{ 
  TestClass *imposter = [imposterizer imposterizeClass:TestClass.class invokable:invocationCapturer ancilliaryProtocols:nil];
  
  STAssertTrue([imposter conformsToProtocol:@protocol(NSObject)], @"Expected to report conforms to protocol.");
}

- (void)testImposterizedProtocolsForwardInvocationsToInvokableForValidRequiredInstanceMethods
{
  id<TestProtocol> imposter = [imposterizer imposterizeProtocol:@protocol(TestProtocol) invokable:invocationCapturer ancilliaryProtocols:nil];
  
  [imposter doSomethingElse];
  
  NSInvocation *lastInvocation = [invocationCapturer.capturedInvocations lastObject];
  STAssertNotNil(lastInvocation, @"Expected forwarded invocation to be captured");
}

- (void)testImposterizedProtocolsForwardInvocationsToInvokableForValidOptionalInstanceMethods
{
  id<TestProtocol> imposter = [imposterizer imposterizeProtocol:@protocol(TestProtocol) invokable:invocationCapturer ancilliaryProtocols:nil];
  
  [imposter doSomethingOptional];
  
  NSInvocation *lastInvocation = [invocationCapturer.capturedInvocations lastObject];
  STAssertNotNil(lastInvocation, @"Expected forwarded invocation to be captured");
}


- (void)testImposterizedProtocolsForwardInvocationsToInvokableForInheritedProtocolInstanceMethods
{
  id<ExtendedTestProtocol> imposter = [imposterizer imposterizeProtocol:@protocol(ExtendedTestProtocol) invokable:invocationCapturer ancilliaryProtocols:nil];
  
  [imposter doSomethingElse];
  
  NSInvocation *lastInvocation = [invocationCapturer.capturedInvocations lastObject];
  STAssertNotNil(lastInvocation, @"Expected forwarded invocation to be captured");
}

- (void)testImposterizedProtocolsRaiseForUnknownInstanceMethods
{
  id imposter = [imposterizer imposterizeProtocol:@protocol(TestProtocol) invokable:invocationCapturer ancilliaryProtocols:nil];
  STAssertThrows([imposter string], @"Expected unknown method to raise exception");
}

- (void)testImposterizedClassesReportTheyRespondToAnyValidProtocolInstanceMethods
{
  TestClass *imposter = [imposterizer imposterizeProtocol:@protocol(TestProtocol) invokable:invocationCapturer ancilliaryProtocols:nil];
  
  STAssertTrue([imposter respondsToSelector:@selector(doSomethingElse)], @"Expected to report responds to selector.");
}

- (void)testImposterizedProtocolsReportTheyConformToTheImposterizedProtocol
{
  TestClass *imposter = [imposterizer imposterizeProtocol:@protocol(TestProtocol) invokable:invocationCapturer ancilliaryProtocols:nil];
  
  STAssertTrue([imposter conformsToProtocol:@protocol(TestProtocol)], @"Expected to report conforms to protocol.");
}

- (void)testImposterizedProtocolsReportTheyConformToTheImposterizedProtocolsInheritedProtocols
{
  TestClass *imposter = [imposterizer imposterizeProtocol:@protocol(ExtendedTestProtocol) invokable:invocationCapturer ancilliaryProtocols:nil];
  
  STAssertTrue([imposter conformsToProtocol:@protocol(TestProtocol)], @"Expected to report conforms to protocol.");
}

- (void)testCanImposterizeClassWithAncilliaryProtocols
{
  TestClass<TestProtocol> *imposter = [imposterizer imposterizeClass:TestClass.class invokable:invocationCapturer ancilliaryProtocols:@[@protocol(TestProtocol)]];
  
  [imposter doSomethingElse];
  
  NSInvocation *lastInvocation = [invocationCapturer.capturedInvocations lastObject];
  STAssertNotNil(lastInvocation, @"Expected forwarded invocation for ancilliar protocol method to be captured");
  
  STAssertTrue([imposter respondsToSelector:@selector(doSomethingElse)], @"Expected to report responds to ancilliary protocol method.");
  STAssertTrue([imposter conformsToProtocol:@protocol(TestProtocol)], @"Expected to report conforms to ancilliary protocol.");
}

- (void)testCanImposterizeProtocolWithAncilliaryProtocols
{
  NSObject<TestProtocol> *imposter = [imposterizer imposterizeProtocol:@protocol(NSObject) invokable:invocationCapturer ancilliaryProtocols:@[@protocol(TestProtocol)]];
  
  [imposter doSomethingElse];
  
  NSInvocation *lastInvocation = [invocationCapturer.capturedInvocations lastObject];
  STAssertNotNil(lastInvocation, @"Expected forwarded invocation for ancilliar protocol method to be captured");
  
  STAssertTrue([imposter respondsToSelector:@selector(doSomethingElse)], @"Expected to report responds to ancilliary protocol method.");
  STAssertTrue([imposter conformsToProtocol:@protocol(TestProtocol)], @"Expected to report conforms to ancilliary protocol.");
}

END_TEST_CASE
