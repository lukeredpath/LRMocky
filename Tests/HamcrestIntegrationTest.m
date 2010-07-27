//
//  HamcrestIntegrationTest.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#define LRMOCKY_SHORTHAND
#define LRMOCKY_SUGAR

#import "TestHelper.h"
#import "LRMocky.h"
#import "FunctionalMockeryTestCase.h"

@interface HamcrestIntegrationTest : FunctionalMockeryTestCase 
{}
@end

@implementation HamcrestIntegrationTest

- (void)testCanExpectInvocationWithEqualObjectAndPass
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) returnSomethingForValue:with(equalTo(@"foo"))];
  }];
  
  [testObject returnSomethingForValue:@"foo"];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

@end
