//
//  LRMockyAutomation.m
//  Timeslips
//
//  Created by Luke Redpath on 05/03/2012.
//  Copyright (c) 2012 LJR Software Limited. All rights reserved.
//

#import "LRMockyAutomation.h"

@implementation LRMockeryAutomation {
  LRMockery *mockery;
}

+ (id)sharedAutomation
{
  static LRMockeryAutomation *__sharedAutomation = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __sharedAutomation = [[LRMockeryAutomation alloc] init];
  });
  return __sharedAutomation;
}

- (void)prepareContextForTestCase:(id)testCase
{
  if (mockery == nil) {
    mockery = [LRMockery mockeryForTestCase:testCase];
  }
}

- (void)checking:(void (^)(LRExpectationBuilder *))expectationBlock
{
  [mockery checking:expectationBlock];
}

- (void)verify:(void (^)(void))block fileName:(NSString *)fileName lineNumber:(int)lineNumber
{
  block();
  LRM_assertContextSatisfied(mockery, fileName, lineNumber);
  mockery = nil;
}

- (LRMockery *)mockery
{
  return mockery;
}

@end

void LRM_check(id testCase, void (^expectationBlock)(LRExpectationBuilder *))
{
  [[LRMockeryAutomation sharedAutomation] prepareContextForTestCase:testCase];
  [[LRMockeryAutomation sharedAutomation] checking:expectationBlock];
}

void LRM_verify(NSString *fileName, int lineNumber, void (^block)(void))
{
  [[LRMockeryAutomation sharedAutomation] verify:block fileName:fileName lineNumber:lineNumber];
}

LRMockery *LRM_automock(id testCase)
{
  [[LRMockeryAutomation sharedAutomation] prepareContextForTestCase:testCase];
  return [[LRMockeryAutomation sharedAutomation] mockery];
}
