//
//  LRMockery.h
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRExpectation.h"
#import "LRTestCase.h"

@class LRExpectationBuilder;
@class SenTestCase;
@class LRMockyStateMachine;
@class LRMockObject;

@interface LRMockery : NSObject {
  NSMutableArray *expectations;
  id<LRTestCaseNotifier> testNotifier;
}

/*--------------------------------------------------------------------------------------
 * @name Creating and initializing Mockeries
 *-------------------------------------------------------------------------------------*/

+ (id)mockeryForTestCase:(id)testCase;
+ (id)mockeryForSenTestCase:(SenTestCase *)testCase;
- (id)initWithNotifier:(id<LRTestCaseNotifier>)aNotifier;

/*--------------------------------------------------------------------------------------
 * @name Creating mocks
 *-------------------------------------------------------------------------------------*/

- (id)mock:(Class)klass;
- (id)mock:(Class)klass named:(NSString *)name;
- (id)protocolMock:(Protocol *)protocol;

/*--------------------------------------------------------------------------------------
 * @name Expecting NSNotifications
 *-------------------------------------------------------------------------------------*/

- (void)expectNotificationNamed:(NSString *)name;
- (void)expectNotificationNamed:(NSString *)name fromObject:(id)sender;

/*--------------------------------------------------------------------------------------
 * @name Creating state machines
 *-------------------------------------------------------------------------------------*/

- (LRMockyStateMachine *)states:(NSString *)name;
- (LRMockyStateMachine *)states:(NSString *)name defaultTo:(NSString *)defaultState;

/*--------------------------------------------------------------------------------------
 * @name Setting up expectations
 *-------------------------------------------------------------------------------------*/

- (void)checking:(void (^)(LRExpectationBuilder *will))expectationBlock;
- (void)addExpectation:(id<LRExpectation>)expectation;

/*--------------------------------------------------------------------------------------
 * @name Checking expectations
 *-------------------------------------------------------------------------------------*/

- (void)assertSatisfied;

/*--------------------------------------------------------------------------------------
 * @name Resetting the current context
 *-------------------------------------------------------------------------------------*/

- (void)reset;

@end

void LRM_assertContextSatisfied(LRMockery *context, NSString *fileName, int lineNumber);

#ifdef LRMOCKY_SUGAR
#define assertContextSatisfied(context) LRM_assertContextSatisfied(context, [NSString stringWithUTF8String:__FILE__], __LINE__)
#endif
