//
//  ExpectationActionsTest.m
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#define LRMOCKY_SHORTHAND
#import "TestHelper.h"
#import "LRMockery.h"
#import "LRExpectationBuilder.h"
#import "LRReturnObjectAction.h"

@interface ExpectationActionsTest : SenTestCase 
{
  LRMockery *context;
  MockTestCase *testCase;
}
@end

@implementation ExpectationActionsTest

- (void)setUp;
{
  testCase = [MockTestCase new];
  context = [[LRMockery mockeryForTestCase:testCase] retain];
}

- (void)testMocksCanReturnAnObjectFromAnExpectedInvocation;
{
  SimpleObject *testObject = [context mock:[SimpleObject class]];
  
  NSString *expectedObject = @"some string";
  
  [context checking:^(LRExpectationBuilder *that){
    [[that oneOf:testObject] returnSomething]; [that will:returnObject(expectedObject)];
  }];
  
  id result = [testObject returnSomething];
  STAssertEquals(expectedObject, result, @"Expected test object to return '%@', but returned %@", expectedObject, result);
  
  [context assertSatisfied];
}

@end
