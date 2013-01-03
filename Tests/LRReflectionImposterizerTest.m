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
- (id)returnsObject;
- (int)returnsInt;
@end

@implementation TestClass
- (void)doSomething {}
- (id)returnsObject { return nil; }
- (int)returnsInt { return 0; }
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

- (void)testImposterizedMethodsThatShouldReturnObjectsReturnNilByDefault
{
  TestClass *imposter = [imposterizer imposterizeClass:TestClass.class invokable:invocationCapturer ancilliaryProtocols:nil];
  
  id result = [imposter returnsObject];

  STAssertNil(result, @"Expected nil result.");
}

- (void)testImposterizedMethodsThatShouldReturnObjectsReturnTheInvocationReturnValueIfSet
{
  TestClass *imposter = [imposterizer imposterizeClass:TestClass.class invokable:invocationCapturer ancilliaryProtocols:nil];
  
  __block NSString *expectedReturnValue = @"result";
  
  [invocationCapturer onInvocation:^(NSInvocation *invocation) {
    [invocation setReturnValue:&expectedReturnValue];
  }];
  
  id result = [imposter returnsObject];
  
  STAssertEqualObjects(expectedReturnValue, result, @"Expected a matching result.");
}

- (void)testImposterizedMethodsThatShouldReturnPrimitivesReturnTheInvocationReturnValueIfSet
{
  TestClass *imposter = [imposterizer imposterizeClass:TestClass.class invokable:invocationCapturer ancilliaryProtocols:nil];
  
  __block int expectedReturnValue = 123;
  
  [invocationCapturer onInvocation:^(NSInvocation *invocation) {
    [invocation setReturnValue:&expectedReturnValue];
  }];
  
  int result = [imposter returnsInt];
  
  STAssertEquals(expectedReturnValue, result, @"Expected a matching result.");
}

END_TEST_CASE
