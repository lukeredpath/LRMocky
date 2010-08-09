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

@interface LRMockery : NSObject {
  NSMutableArray *expectations;
  id<LRTestCaseNotifier> testNotifier;
}
+ (id)mockeryForTestCase:(id)testCase;
+ (id)mockeryForSenTestCase:(SenTestCase *)testCase;
- (id)initWithNotifier:(id<LRTestCaseNotifier>)aNotifier;
- (id)mock:(Class)klass;
- (id)mock:(Class)klass named:(NSString *)name;
- (LRMockyStateMachine *)states:(NSString *)name;
- (LRMockyStateMachine *)states:(NSString *)name defaultTo:(NSString *)defaultState;
- (void)checking:(void (^)(LRExpectationBuilder *will))expectationBlock;
- (void)addExpectation:(id<LRExpectation>)expectation;
- (void)assertSatisfiedInFile:(NSString *)fileName lineNumber:(int)lineNumber;
- (void)assertSatisfied;
- (void)dispatchInvocation:(NSInvocation *)invocation;
- (void)reset;
@end

void LRM_assertContextSatisfied(LRMockery *context, NSString *fileName, int lineNumber);

#ifdef LRMOCKY_SUGAR
#define assertContextSatisfied(context) LRM_assertContextSatisfied(context, [NSString stringWithUTF8String:__FILE__], __LINE__)
#endif
