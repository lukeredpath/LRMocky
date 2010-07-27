//
//  FunctionalMockeryTestCase.h
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestCase.h>

@class LRMockery;
@class FakeTestCase;
@class SimpleObject;

@interface FunctionalMockeryTestCase : SenTestCase {
  LRMockery *context;
  FakeTestCase *testCase;
  SimpleObject *testObject;
}
@end
