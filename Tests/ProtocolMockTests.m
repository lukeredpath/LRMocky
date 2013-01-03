//
//  ProtocolMockTests.m
//  Mocky
//
//  Created by Luke Redpath on 24/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "FunctionalMockeryTestCase.h"

@protocol SimpleProtocol
- (void)requiredMethod;
@optional
- (void)optionalMethod;
@end

DEFINE_FUNCTIONAL_TEST_CASE(ProtocolMockTests) {
  id mockObject;
}

- (void)setUp
{
  [super setUp];
  mockObject = [[context protocolMock:@protocol(SimpleProtocol)] retain];
}

- (void)testCanSetExpectationsOnRequiredMethods
{
  [context check:^{
    [[expectThat(mockObject) receives] requiredMethod];
  }];
  
  [mockObject requiredMethod];

  assertContextSatisfied(context);
  assertThat(testCase, passed());
}

- (void)testCanSetExpectationsOnOptionalMethods
{
  [context check:^{
    [[expectThat(mockObject) receives] optionalMethod];
  }];
  
  [mockObject optionalMethod];
  
  assertContextSatisfied(context);
  assertThat(testCase, passed());
}

END_TEST_CASE
