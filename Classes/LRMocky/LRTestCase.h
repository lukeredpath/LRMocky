//
//  LRTestCase.h
//  Mocky
//
//  Created by Luke Redpath on 22/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LRTestCaseNotifier <NSObject>
- (void)notifiesFailureWithException:(NSException *)exception;
@end

@class SenTestCase;

@interface LRSenTestCaseNotifier : NSObject <LRTestCaseNotifier>
{
  SenTestCase *testCase;
}
+ (id)notifierForTestCase:(SenTestCase *)aTestCase;
- (id)initWithSenTestCase:(SenTestCase *)aTestCase;
@end
