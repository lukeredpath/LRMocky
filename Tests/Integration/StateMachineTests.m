//
//  StateMachineTests.m
//  Mocky
//
//  Created by Luke Redpath on 30/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "FunctionalMockeryTestCase.h"

@protocol ToMakeTestCompile <NSObject>

- (void)becomes:(NSString *)state;
- (void)equals:(NSString *)state;

@end

@interface LRSynchroniser : NSObject

+ (id)synchroniser;
+ (id)synchroniserWithTimeout:(NSTimeInterval)timeout;
- (void)waitUntil:(id<LRStatePredicate>)statePredicate;

@end

@implementation LRSynchroniser {
  NSTimeInterval _timeout;
}

+ (id)synchroniser
{
  return [[self alloc] initWithTimeout:5];
}

+ (id)synchroniserWithTimeout:(NSTimeInterval)timeout
{
  return [[self alloc] initWithTimeout:timeout];
}

- (id)initWithTimeout:(NSTimeInterval)timeout
{
  self = [super init];
  if (self) {
    _timeout = timeout;
  }
  return self;
}

- (void)waitUntil:(id<LRStatePredicate>)statePredicate
{
  if ([statePredicate isActive]) return;
  
  NSDate *waitUntil = [NSDate dateWithTimeIntervalSinceNow:_timeout];

  BOOL predicateSatisfied = NO;
  NSInteger pollingInterval = 0.1;
  
  while (!predicateSatisfied) {
    NSDate *runUntil = [NSDate dateWithTimeIntervalSinceNow:pollingInterval];
    
    if ([runUntil earlierDate:waitUntil] == waitUntil) {
      break;
    }
    [[NSRunLoop currentRunLoop] runUntilDate:runUntil];

    predicateSatisfied = [statePredicate isActive];
  }
}

@end

DEFINE_FUNCTIONAL_TEST_CASE(StateMachineTests) {
  LRMockyStateMachine *readiness;
}

- (void)setUp
{
  [super setUp];
  
  readiness = [[context states:@"readiness"] startsAs:@"unready"];
}

- (void)testCanConstrainExpectationsToOccurWithinGivenState
{
  [context check:^{
    whenState([readiness equals:@"ready"], ^{
      [[expectThat(testObject) receives] doSomething];
    });
  }];
  
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, failedWithNumberOfFailures(2));
}

- (void)testAllowsExpectationsToOccurWhenAlreadyInCorrectState
{
  [readiness transitionTo:@"ready"];
  
  [context check:^{
    whenState([readiness equals:@"ready"], ^{
      [[expectThat(testObject) receives] doSomething];
    });
  }];
  
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanTriggerStateChangesAsResultOfExpectation
{
  [context check:^{
    [allowing(testObject) doSomething]; [then state:readiness becomes:@"ready"];
  }];
  
  [testObject doSomething];
  
  assertThat(readiness.currentState, equalTo(@"ready"));
  assertThat(testCase, passed());
}

- (void)testMultipleExpectationsWithStates
{
  [context check:^{
    [allowing(testObject) doSomething]; [then state:readiness becomes:@"ready"];
    
    whenState([readiness equals:@"ready"], ^{
      [[expectThat(testObject) receives] doSomethingElse];
    });
  }];
  
  [testObject doSomething];
  [testObject doSomethingElse];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testUsingStatesToTestAsynchronousCode
{
  LRSynchroniser *synchroniser = [LRSynchroniser synchroniser];
  
  [readiness transitionTo:@"waiting"];
  
  [context check:^{
    [[expectThat(testObject) receives] doSomething]; [then state:readiness becomes:@"ready"];
  }];
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [testObject doSomething];
  });
  
  [synchroniser waitUntil:[readiness equals:@"ready"]];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testUsingStatesToTestAsynchronousCodeWithTimeout
{
  LRSynchroniser *synchroniser = [LRSynchroniser synchroniserWithTimeout:0.3];
  
  [readiness transitionTo:@"waiting"];
  
  [context check:^{
    [[expectThat(testObject) receives] doSomething]; [then state:readiness becomes:@"ready"];
  }];
  
  double delayInFractionalSeconds = 0.4;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInFractionalSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [testObject doSomething];
  });
  
  [synchroniser waitUntil:[readiness equals:@"ready"]];
  [context assertSatisfied];
  
  assertThat(testCase, failedWithNumberOfFailures(1));
}

END_TEST_CASE
