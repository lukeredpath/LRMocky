//
//  LRClassImposterizerTest.m
//  Mocky
//
//  Created by Luke Redpath on 24/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#define LRMOCKY_SUGAR
#define LRMOCKY_SHORTHAND
#import "LRMocky.h"
#import "HCBlockMatcher.h"
#import "LRClassImposterizer.h"
#import "LRObjectImposterizer.h"
#import "LRProtocolImposterizer.h"

@interface MyTestClass : NSObject
- (void)anInstanceMethod;
+ (void)aClassMethod;
@end

@implementation MyTestClass
- (void)anInstanceMethod {}
+ (void)aClassMethod {}
@end

id invocationForSelector(SEL selector)
{
  return satisfiesBlock([NSString stringWithFormat:@"an invocation for @selector(%@)", NSStringFromSelector(selector)], ^(id actual) {
    return (BOOL)([(NSInvocation *)actual selector] == selector);
  });
}

#pragma mark -

@interface ClassImposterizerTest : SenTestCase
{
  LRMockery *context;
  LRClassImposterizer *imposterizer;
  id mockDelegate;
  NSInvocation *handledInvocation;
}
@end

@implementation ClassImposterizerTest

- (void)setUp
{
  context = [[LRMockery mockeryForTestCase:self] retain];
  imposterizer = [[LRClassImposterizer alloc] initWithClass:[MyTestClass class]];
  imposterizer.delegate = self;
}

- (void)testShouldReportRespondsToInstanceMethods
{
  assertTrue([imposterizer respondsToSelector:@selector(anInstanceMethod)]);
}

- (void)testForwardMethodCallsToItsDelegate
{
  [imposterizer performSelector:@selector(anInstanceMethod)];
  assertThat(handledInvocation, is(invocationForSelector(@selector(anInstanceMethod))));
}

- (void)handleImposterizedInvocation:(NSInvocation *)invocation
{
  handledInvocation = [invocation retain];
}

@end

#pragma mark -

@interface ObjectImposterizerTest : SenTestCase
{
  LRMockery *context;
  LRObjectImposterizer *imposterizer;
  id mockDelegate;
  NSInvocation *handledInvocation;
}
@end

@implementation ObjectImposterizerTest

- (void)setUp
{
  context = [[LRMockery mockeryForTestCase:self] retain];
  imposterizer = [[LRObjectImposterizer alloc] initWithObject:[[MyTestClass new] autorelease]];
  imposterizer.delegate = self;
}

- (void)testShouldReportRespondsToInstanceMethods
{
  assertTrue([imposterizer respondsToSelector:@selector(anInstanceMethod)]);
}

- (void)testForwardMethodCallsToItsDelegate
{
  [imposterizer performSelector:@selector(anInstanceMethod)];
  assertThat(handledInvocation, is(invocationForSelector(@selector(anInstanceMethod))));
}

- (void)handleImposterizedInvocation:(NSInvocation *)invocation
{
  handledInvocation = [invocation retain];
}

@end

#pragma mark -

@protocol TestProtocol
- (void)someRequiredMethod;
@optional
- (void)someOptionalMethod;
@end

@interface ProtocolImposterizerTest : SenTestCase
{
  LRMockery *context;
  LRProtocolImposterizer *imposterizer;
  id mockDelegate;
  NSInvocation *handledInvocation;
}
@end

@implementation ProtocolImposterizerTest

- (void)setUp
{
  context = [[LRMockery mockeryForTestCase:self] retain];
  imposterizer = [[LRProtocolImposterizer alloc] initWithProtocol:@protocol(TestProtocol)];
  imposterizer.delegate = self;
}

- (void)testShouldReportRespondsToRequiredMethods
{
  assertTrue([imposterizer respondsToSelector:@selector(someRequiredMethod)]);
}

- (void)testShouldReportRespondsToOptionalMethods
{
  assertTrue([imposterizer respondsToSelector:@selector(someOptionalMethod)]);
}

- (void)testForwardsRequiredMethodCallsToItsDelegate
{
  [imposterizer performSelector:@selector(someRequiredMethod)];
  assertThat(handledInvocation, is(invocationForSelector(@selector(someRequiredMethod))));
}

- (void)testForwardsOptionalMethodCallsToItsDelegate
{
  [imposterizer performSelector:@selector(someOptionalMethod)];
  assertThat(handledInvocation, is(invocationForSelector(@selector(someOptionalMethod))));
}

- (void)handleImposterizedInvocation:(NSInvocation *)invocation
{
  handledInvocation = [invocation retain];
}

@end
