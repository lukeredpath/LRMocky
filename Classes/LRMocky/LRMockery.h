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
#import "LRInvocationDispatcher.h"
#import "LRExpectationCollector.h"

@class LRInvocationExpectationBuilder;
@class SenTestCase;
@class LRMockyStateMachine;
@class OLD_LRMockObject;


/** Represents a context in which mocks are created and verified.
 
 */
@interface LRMockery : NSObject <LRInvocationDispatcher, LRExpectationCollector> {
  NSMutableArray *expectations;
  NSMutableArray *mockObjects;
  id<LRTestCaseNotifier> testNotifier;
}
@property (nonatomic, assign) BOOL automaticallyResetWhenAsserting;

///------------------------------------------------------------------------------------/
/// @name Creating and initializing 
///------------------------------------------------------------------------------------/

/** Creates a mocking context for a generic test case.
 
 @param testCase The current test case.
 @return An auto-released LRMockery instance.
 */
+ (id)mockeryForTestCase:(id)testCase;

/** Creates a mocking context for a SenTest test case.
 
 Mocky currently only supports SenTest and SenTest-derived frameworks so currently, 
 calling this is the same as calling mockeryForTestCase:.
 
 @param testCase The current SenTest test case.
 @return An auto-released LRMockery instance.
 */
+ (id)mockeryForSenTestCase:(SenTestCase *)testCase;

/** Initializes a new mocking context.
 
 The notifier is used to notify tests of failures or other events, and is used as an
 adapter to abstract away the underlying test framework. Different notifier 
 implementations can be used to add support for other testing frameworks.
 
 @param aNotifier A concrete notifier implementation
 @see LRTestCaseNotifier
 @return An initialized Mockery that will report failures using the given notifier.
 */
- (id)initWithNotifier:(id<LRTestCaseNotifier>)aNotifier;

///------------------------------------------------------------------------------------/
/// @name Creating mocks
///------------------------------------------------------------------------------------/

/** Creates a new mock object for a given Class or Protocol.
 
 Class mocks act as stand-ins for the given class. By default, any invocations performed
 on the mock that haven't been previously configured will raise an exception.
 
 By default, mocks will have a name of <mock Type> and this will be used in any error output.
 
 @param klass The class you wish to mock.
 @return An auto-released mock object that acts as an imposter for the specified class/protocol.
 */
- (id)mock:(id)klassOrProtocol;

/** Creates a new mock object for a given Class or Protocol, with a custom name.
 *
 * The mocks name will be used in its description in any error output.
 *
 @param klass The class you with to mock.
 @param name A descriptive name for the mock.
 @return An auto-released mock object that acts as an imposter for the specified class/protocol.
 */
- (id)mock:(id)klassOrProtocol named:(NSString *)name;

///------------------------------------------------------------------------------------/
/// @name Expecting NSNotifications
///------------------------------------------------------------------------------------/

/** Sets an expectation that a NSNotification will be posted.
 
 Whilst normal expectations are set on mock objects, Mocky has special support for
 setting notification expectations.
 
 Simply, Mocky will observe the named notification to see if was posted by the default
 NSNotificationCenter. If it is not, the expectation will fail.
 
 @param name The name of the notification you expect to be posted.
 */
- (void)expectNotificationNamed:(NSString *)name;

/** Sets an expectation that a NSNotification will be posted from a specific object.
 
 As above, although only notifications posted by the specified sender will be observed.
 
 @param name The name of the notification you expect to be posted.
 @param sender The object you expect to post the notification.
 */
- (void)expectNotificationNamed:(NSString *)name fromObject:(id)sender;

///------------------------------------------------------------------------------------/
/// @name Creating state machines
///------------------------------------------------------------------------------------/

/** Creates a new state machine.
 
 State machines can be used in conjunction with expectations to check that they only 
 occur in a certain state. 
 
 @param name A descriptive name for the state this represents.
 @see LRMockyStateMachine
 */
- (LRMockyStateMachine *)states:(NSString *)name;

/** Creates a new state machine in a default state.
 
 @param name A descriptive name for the state this represents.
 @param defaultState The default state for the state machine.
 @see states:
 */
- (LRMockyStateMachine *)states:(NSString *)name defaultTo:(NSString *)defaultState;

///------------------------------------------------------------------------------------/
/// @name Setting up expectations
///------------------------------------------------------------------------------------/

/** Starts a new expectation checking block.
 
 Checking blocks are used to configure the expectations within the current mocking
 context. 
 
 checki: can be called multiple times, all expectations created within each
 block will be appended to the previous expectations.
 
 @param expectationBlock An expectation block containing expectation calls.
 @see LRExpectationBuilder
 */
- (void)check:(__weak dispatch_block_t)expectationBlock;

///------------------------------------------------------------------------------------/
/// @name Checking expectations
///------------------------------------------------------------------------------------/

/** Evaluates all expectations to check that they are satisfied.
 
 In order for your expectations to be verified, this method needs to be called at the
 end of your test case.
 
 In order for Xcode to provide useful error information when an expectation fails, it
 needs to know the line number of file in which this method was called. To that end, 
 Mocky provides a macro, assertContextSatisfied(context) that should be called in place 
 of this method.
 
 This method will not throw an exception if an expectation fails; it will directly 
 inform the test case using the notifier it was initialized with.
 */
- (void)assertSatisfied;

///------------------------------------------------------------------------------------/
/// @name Resetting the current context
///------------------------------------------------------------------------------------/

/** Removes all expectations from the current context. */
- (void)reset;

@end

/** Calls [LRMockery assertSatisifed] on the given context, passing in the relevant file
    name and line number information. 
 
 If LRMOCKY_SUGAR is defined (recommended), you can simply call the helper macro,
 assertContextSatisifed(context), which will call this function with the correct
 file and line information for you.
 */
void LRM_assertContextSatisfied(LRMockery *context, NSString *fileName, int lineNumber);

#ifdef LRMOCKY_SUGAR
#define assertContextSatisfied(context) LRM_assertContextSatisfied(context, [NSString stringWithUTF8String:__FILE__], __LINE__)
#endif
