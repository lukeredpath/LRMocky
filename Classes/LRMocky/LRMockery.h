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

@interface LRMockery : NSObject {
  NSMutableArray *expectations;
  id<LRTestCaseNotifier> testNotifier;
}
+ (id)mockeryForTestCase:(id)testCase;
+ (id)mockeryForSenTestCase:(SenTestCase *)testCase;
- (id)initWithNotifier:(id<LRTestCaseNotifier>)aNotifier;
- (id)mock:(Class)klass;
- (id)mock:(Class)klass named:(NSString *)name;
- (void)checking:(void (^)(LRExpectationBuilder *will))expectationBlock;
- (void)addExpectation:(id<LRExpectation>)expectation;
- (void)assertSatisfied;
- (void)dispatchInvocation:(NSInvocation *)invocation;
@end
