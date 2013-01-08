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
  assertNotNil(lastInvocation);
}

- (void)testImposterizedClassesRaiseForUnknownInstanceMethods
{
  id imposter = [imposterizer imposterizeClass:TestClass.class invokable:invocationCapturer ancilliaryProtocols:nil];
  STAssertThrows([imposter string], @"Expected unknown method to raise exception");
}

- (void)testImposterizedClassesReportTheyRespondToAnyValidClassInstanceMethods
{
  TestClass *imposter = [imposterizer imposterizeClass:TestClass.class invokable:invocationCapturer ancilliaryProtocols:nil];
  
  assertTrue([imposter respondsToSelector:@selector(doSomething)]);
}

- (void)testImposterizedClassesReportTheyConformToAnyInheritedProtocols
{ 
  TestClass *imposter = [imposterizer imposterizeClass:TestClass.class invokable:invocationCapturer ancilliaryProtocols:nil];
  
  assertTrue([imposter conformsToProtocol:@protocol(NSObject)]);
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

  assertNotNil([invocationCapturer.capturedInvocations lastObject]);
}

- (void)testImposterizedProtocolsForwardInvocationsToInvokableForInheritedProtocolInstanceMethods
{
  id<ExtendedTestProtocol> imposter = [imposterizer imposterizeProtocol:@protocol(ExtendedTestProtocol) invokable:invocationCapturer ancilliaryProtocols:nil];
  
  [imposter doSomethingElse];
  
  assertNotNil([invocationCapturer.capturedInvocations lastObject]);
}

- (void)testImposterizedProtocolsRaiseForUnknownInstanceMethods
{
  id imposter = [imposterizer imposterizeProtocol:@protocol(TestProtocol) invokable:invocationCapturer ancilliaryProtocols:nil];
  STAssertThrows([imposter string], @"Expected unknown method to raise exception");
}

- (void)testImposterizedClassesReportTheyRespondToAnyValidProtocolInstanceMethods
{
  TestClass *imposter = [imposterizer imposterizeProtocol:@protocol(TestProtocol) invokable:invocationCapturer ancilliaryProtocols:nil];
  
  assertTrue([imposter respondsToSelector:@selector(doSomethingElse)]);
}

- (void)testImposterizedProtocolsReportTheyConformToTheImposterizedProtocol
{
  TestClass *imposter = [imposterizer imposterizeProtocol:@protocol(TestProtocol) invokable:invocationCapturer ancilliaryProtocols:nil];
  
  assertTrue([imposter conformsToProtocol:@protocol(TestProtocol)]);
}

- (void)testImposterizedProtocolsReportTheyConformToTheImposterizedProtocolsInheritedProtocols
{
  TestClass *imposter = [imposterizer imposterizeProtocol:@protocol(ExtendedTestProtocol) invokable:invocationCapturer ancilliaryProtocols:nil];
  
  assertTrue([imposter conformsToProtocol:@protocol(TestProtocol)]);
}

- (void)testCanImposterizeClassWithAncilliaryProtocols
{
  TestClass<TestProtocol> *imposter = [imposterizer imposterizeClass:TestClass.class invokable:invocationCapturer ancilliaryProtocols:@[@protocol(TestProtocol)]];
  
  [imposter doSomethingElse];
  
  NSInvocation *lastInvocation = [invocationCapturer.capturedInvocations lastObject];

  assertNotNil(lastInvocation);
  assertTrue([imposter respondsToSelector:@selector(doSomethingElse)]);
  assertTrue([imposter conformsToProtocol:@protocol(TestProtocol)]);
}

- (void)testCanImposterizeProtocolWithAncilliaryProtocols
{
  NSObject<TestProtocol> *imposter = [imposterizer imposterizeProtocol:@protocol(NSObject) invokable:invocationCapturer ancilliaryProtocols:@[@protocol(TestProtocol)]];
  
  [imposter doSomethingElse];
  
  NSInvocation *lastInvocation = [invocationCapturer.capturedInvocations lastObject];

  assertNotNil(lastInvocation);
  assertTrue([imposter respondsToSelector:@selector(doSomethingElse)]);
  assertTrue([imposter conformsToProtocol:@protocol(TestProtocol)]);
}

- (void)testImposterizedMethodsThatShouldReturnObjectsReturnNilByDefault
{
  TestClass *imposter = [imposterizer imposterizeClass:TestClass.class invokable:invocationCapturer ancilliaryProtocols:nil];
  
  id result = [imposter returnsObject];

  assertNil(result);
}

- (void)testImposterizedMethodsThatShouldReturnObjectsReturnTheInvocationReturnValueIfSet
{
  TestClass *imposter = [imposterizer imposterizeClass:TestClass.class invokable:invocationCapturer ancilliaryProtocols:nil];
  
  __block NSString *expectedReturnValue = @"result";
  
  [invocationCapturer onInvocation:^(NSInvocation *invocation) {
    [invocation setReturnValue:&expectedReturnValue];
  }];
  
  id result = [imposter returnsObject];
  
  assertThat(result, equalTo(expectedReturnValue));
}

- (void)testImposterizedMethodsThatShouldReturnPrimitivesReturnTheInvocationReturnValueIfSet
{
  TestClass *imposter = [imposterizer imposterizeClass:TestClass.class invokable:invocationCapturer ancilliaryProtocols:nil];
  
  __block int expectedReturnValue = 123;
  
  [invocationCapturer onInvocation:^(NSInvocation *invocation) {
    [invocation setReturnValue:&expectedReturnValue];
  }];
  
  int result = [imposter returnsInt];
  
  assertThat(@(result), equalTo(@(expectedReturnValue)));
}

END_TEST_CASE
