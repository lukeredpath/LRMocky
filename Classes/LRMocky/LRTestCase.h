//
//  LRTestCase.h
//  Mocky
//
//  Created by Luke Redpath on 22/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LRTestCase <NSObject>

- (void)failWithException:(NSException *)exception;

@end

@class SenTestCase;

@interface LRSenTestCaseAdapter : NSObject <LRTestCase>
{
  SenTestCase *testCase;
}
+ (id)adapt:(SenTestCase *)aTestCase;
- (id)initWithSenTestCase:(SenTestCase *)aTestCase;
@end
