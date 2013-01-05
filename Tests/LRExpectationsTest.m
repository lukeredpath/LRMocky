//
//  LRExpectationsTest.m
//  Mocky
//
//  Created by Luke Redpath on 04/01/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#define MOCKY_SHORTHAND
#import "TestHelper.h"
#import "LRExpectations.h"
#import "LRInvocationExpectation.h"
#import "LRMockObject.h"
#import "LRExpectationCardinality.h"
#import "LRReflectionImposterizer.h"
#import "HCBaseMatcher.h"
#import "HCDescription.h"

@interface CollectsExpectations : NSObject <LRExpectationCollector>

@property (nonatomic, readonly) NSArray *expectations;

@end

@implementation CollectsExpectations {
  NSMutableArray *_expectations;
}

@synthesize expectations = _expectations;

- (id)init
{
  self = [super init];
  if (self) {
    _expectations = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)addExpectation:(id<LRExpectation>)expectation
{
  [_expectations addObject:expectation];
}

- (void)clearExpectations
{
  [_expectations removeAllObjects];
}

@end

@interface FakeInvocationDispatcher : NSObject <LRInvocationDispatcher>
@end

@implementation FakeInvocationDispatcher

- (void)dispatch:(NSInvocation *)invocation
{}

@end

/* In order for mock objects used in tests to behave as they would when
   created through a mockery, they need to be imposterized. 
 */
id aMockObject(void) {
  static id<LRImposterizer> imposterizer = nil;
  
  if (imposterizer == nil) {
    imposterizer = [[LRReflectionImposterizer alloc] init];
  }
  
  LRMockObject *mockObject = [[LRMockObject alloc] initWithInvocationDispatcher:[[FakeInvocationDispatcher alloc] init] mockedType:[SimpleObject class] name:@"test mock"];

  return [imposterizer imposterizeClass:SimpleObject.class invokable:mockObject ancilliaryProtocols:@[@protocol(LRCaptureControl)]];
}

@interface LRInvocationExpectationMatcher : HCBaseMatcher

- (id)initWithTargetObject:(id)target selector:(SEL)selector;

@end

@implementation LRInvocationExpectationMatcher {
  id _target;
  SEL _selector;
  id<LRExpectationCardinality> _cardinality;
}

- (id)initWithTargetObject:(id)target selector:(SEL)selector
{
  self = [super init];
  if (self) {
    _target = target;
    _selector = selector;
  }
  return self;
}

- (id)withCardinalityOf:(id<LRExpectationCardinality>)cardinality
{
  _cardinality = cardinality;
  return self;
}

- (BOOL)matches:(id)item
{
  if (![item isKindOfClass:[LRInvocationExpectation class]]) {
    return NO;
  }
  LRInvocationExpectation *expectation = item;
  
  if (expectation.target != _target) {
    return NO;
  }
  if (expectation.selector != _selector) {
    return NO;
  }
  
  if (_cardinality && ![expectation.cardinality isEqual:_cardinality]) {
    return NO;
  }
  
  return YES;
}

- (void)describeTo:(id<HCDescription>)description
{
  [description appendText:[NSString stringWithFormat:@"an <LRInvocationExpectation> for [%@ %@]", _target, NSStringFromSelector(_selector)]];
}

@end

LRInvocationExpectationMatcher<HCMatcher> *expectationFor(id object, SEL selector)
{
  return [[LRInvocationExpectationMatcher alloc] initWithTargetObject:object selector:selector];
}

@interface LRInvocationIsSatisfiedWhenBlockCalled : HCBaseMatcher

- (id)initWithBlock:(dispatch_block_t)block;

@end

@implementation LRInvocationIsSatisfiedWhenBlockCalled {
  dispatch_block_t _block;
}

- (id)initWithBlock:(dispatch_block_t)block;
{
  self = [super init];
  if (self) {
    _block = [block copy];
  }
  return self;
}

- (BOOL)matches:(id)item
{
  if (![item conformsToProtocol:@protocol(LRExpectation)]) {
    return NO;
  }
  
  id<LRExpectation> expectation = item;
  
  _block();
  
  return [expectation isSatisfied];
}

- (void)describeTo:(id<HCDescription>)description
{
  [description appendText:@"to be satisified after calling block"];
}

@end

LRInvocationIsSatisfiedWhenBlockCalled<HCMatcher> *isSatisfiedAfterCalling(dispatch_block_t block)
{
  return [[LRInvocationIsSatisfiedWhenBlockCalled alloc] initWithBlock:block];
}

DEFINE_TEST_CASE(LRExpectationsTest) {
  LRExpectations *expectations;
  CollectsExpectations *collector;
}

- (void)setUp
{
  expectations = [[LRExpectations alloc] init];
  collector = [[CollectsExpectations alloc] init];
}

- (void)testCollectsNoExpectationsWhenNothingConfigured
{
  [expectations buildExpectations:collector];
  
  assertThat(collector.expectations, empty());
}

- (void)testCreatingExpectationWithDefaultCardinality
{
  id mockObject = aMockObject();
  
  [[[expectations expectThat:mockObject] receives] doSomething];
  
  [expectations buildExpectations:collector];
  
  LRInvocationExpectation *expectation = [collector.expectations lastObject];
  
  assertThat(expectation, hasProperty(@"target", mockObject));
  
  //assertThat(collector.expectations, hasItem([expectationFor(mockObject, @selector(doSomething)) withCardinalityOf:exactly(1)]));
}

- (void)testCreatingExpectationWithExactlyCardinality
{
  id mockObject = aMockObject();
  
  [[[expectations expectThat:mockObject] receivesExactly:1] doSomething];
  
  [expectations buildExpectations:collector];
  
  assertThat(collector.expectations, hasItem([expectationFor(mockObject, @selector(doSomething)) withCardinalityOf:exactly(1)]));
}

- (void)testCreatingExpectationWithAtLeastCardinality
{
  id mockObject = aMockObject();
  
  [[[expectations expectThat:mockObject] receivesAtLeast:1] doSomething];
  
  [expectations buildExpectations:collector];
  
  assertThat(collector.expectations, hasItem([expectationFor(mockObject, @selector(doSomething)) withCardinalityOf:atLeast(1)]));
}

- (void)testCreatingExpectationWithAtMostCardinality
{
  id mockObject = aMockObject();
  
  [[[expectations expectThat:mockObject] receivesAtMost:1] doSomething];
  
  [expectations buildExpectations:collector];
  
  assertThat(collector.expectations, hasItem([expectationFor(mockObject, @selector(doSomething)) withCardinalityOf:atMost(1)]));
}

- (void)testCreatingExpectationWithBetweenCardinality
{
  id mockObject = aMockObject();
  
  [[[expectations expectThat:mockObject] receivesBetween:1 and:3] doSomething];
  
  [expectations buildExpectations:collector];
  
  assertThat(collector.expectations, hasItem([expectationFor(mockObject, @selector(doSomething)) withCardinalityOf:between(1, 3)]));
}

- (void)testCreatingExpectationWithCardinalitySyntaticSugar
{
  id mockObject = aMockObject();
  
  [[[[expectations expectThat:mockObject] receivesExactly:1] of] doSomething];
  
  [expectations buildExpectations:collector];
  
  assertThat(collector.expectations, hasItem([expectationFor(mockObject, @selector(doSomething)) withCardinalityOf:exactly(1)]));
}

- (void)testCreatingMultipleExpectations
{
  id mockObject = aMockObject();
  
  [[[expectations expectThat:mockObject] receives] doSomething];
  [[[expectations expectThat:mockObject] receives] doSomethingElse];
  
  [expectations buildExpectations:collector];
  
  id<HCMatcher> hasExpectedItems = hasItems(expectationFor(mockObject, @selector(doSomething)),
                                            expectationFor(mockObject, @selector(doSomethingElse)), nil);
  
  assertThat(collector.expectations, hasExpectedItems);
}

- (void)testBuildingExpectationsUsingBlockGivesGlobalAccessToBuilderWithinBlock
{
  __block LRExpectations *builder = nil;
  
  id returnedBuilder = [LRExpectations captureExpectationsWithBlock:^{
    builder = expectThat(aMockObject());
  }];
  
  assertThat(builder, instanceOf(LRExpectations.class));
  assertThat(returnedBuilder, equalTo(builder));
}

- (void)testBuildingExpectationsUsingBlockReturnsBuilderInstanceButRemovesGlobalAccessOutsideBlock
{
  id returnedBuilder = [LRExpectations captureExpectationsWithBlock:^{}];
  
  LRExpectations *globalBuilder = expectThat(aMockObject());;
  
  assertThat(returnedBuilder, instanceOf(LRExpectations.class));
  assertThat(globalBuilder, nilValue());
}

- (void)testCreatingExpectationForNotificationOnDefaultCenterFromAnySender
{
  [expectations expectNotification:@"TestNotification"];
  [expectations buildExpectations:collector];
  
  assertThat(collector.expectations.lastObject, isSatisfiedAfterCalling(^{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:nil];
  }));
}

- (void)testCreatingExpectationForNotificationOnDefaultCenterFromSpecifiedSender
{
  [[expectations expectNotification:@"TestNotification"] fromSender:self];
  [expectations buildExpectations:collector];
  
  assertThat(collector.expectations.lastObject, isSatisfiedAfterCalling(^{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:self];
  }));
}

- (void)testCreatingExpectationForNotificationOnDefaultCenterFromFuzzyMatchedSender
{
  [[expectations expectNotification:@"TestNotification"] fromSender:instanceOf(SenTestCase.class)];
  [expectations buildExpectations:collector];
  
  assertThat(collector.expectations.lastObject, isSatisfiedAfterCalling(^{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:self];
  }));
}

- (void)testCreatingExpectationForNotificationFromDifferentNotificationCenter
{
  NSNotificationCenter *anotherCenter = [[NSNotificationCenter alloc] init];
  
  [[expectations expectNotification:@"TestNotification"] viaNotificationCenter:anotherCenter];
  [expectations buildExpectations:collector];
  
  assertThat(collector.expectations.lastObject, isSatisfiedAfterCalling(^{
    [anotherCenter postNotificationName:@"TestNotification" object:nil];
  }));
}

END_TEST_CASE
