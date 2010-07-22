//
//  LRTestCase.m
//  Mocky
//
//  Created by Luke Redpath on 22/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRTestCase.h"
#import <SenTestingKit/SenTestingKit.h>

@implementation LRSenTestCaseAdapter

+ (id)adapt:(SenTestCase *)aTestCase;
{
  return [[[self alloc] initWithSenTestCase:aTestCase] autorelease];
}

- (id)initWithSenTestCase:(SenTestCase *)aTestCase;
{
  if (self = [super init]) {
    testCase = [aTestCase retain];
  }
  return self;
}

- (void)dealloc;
{
  [testCase release];
  [super dealloc];
}

- (void)failWithException:(NSException *)exception;
{
  [testCase failWithException:exception];
}

@end
