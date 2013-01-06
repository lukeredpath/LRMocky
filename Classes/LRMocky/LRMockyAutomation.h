//
//  LRMockyAutomation.h
//  Timeslips
//
//  Created by Luke Redpath on 05/03/2012.
//  Copyright (c) 2012 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LRMOCKY_SUGAR
#define LRMOCKY_KIWI_COMPATIBILITY_MODE
#import "LRMocky.h"

void LRM_check(id testCase, void (^expectationBlock)(LRInvocationExpectationBuilder *));
void LRM_verify(NSString *fileName, int lineNumber, void (^block)(void));
LRMockery *LRM_automock(id testCase);

@interface LRMockeryAutomation : NSObject
+ (id)sharedAutomation;
- (void)prepareContextForTestCase:(id)testCase;
- (void)checking:(void (^)(LRInvocationExpectationBuilder *))expectationBlock;
- (void)verify:(void (^)(void))block fileName:(NSString *)fileName lineNumber:(int)lineNumber;
- (LRMockery *)mockery;
@end

#define automock  LRM_automock(self)
#define xcheck(block)  LRM_check(self, block)
#define verifyWith(block) LRM_verify([NSString stringWithUTF8String:__FILE__], __LINE__, block)
