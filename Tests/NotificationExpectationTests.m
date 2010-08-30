//
//  NotificationExpectationTests.m
//  Mocky
//
//  Created by Luke Redpath on 31/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "FunctionalMockeryTestCase.h"

@interface NotificationExpectationTests : FunctionalMockeryTestCase
{}
@end


@implementation NotificationExpectationTests

- (void)testCanExpectNotificationWithNameAndPass
{
  [context expectNotificationNamed:@"SomeTestNotification"];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"SomeTestNotification" object:nil];
  
  assertContextSatisfied(context);
  assertThat(testCase, passed());
}

- (void)testCanExpectNotificationWithNameAndFail
{
  [context expectNotificationNamed:@"SomeTestNotification"];

  assertContextSatisfied(context);
  assertThat(testCase, failedWithNumberOfFailures(1));
}

- (void)testCanExpectNotificationWithSpecificSenderAndPass
{
  [context expectNotificationNamed:@"SomeTestNotification" fromObject:self];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"SomeTestNotification" object:self];
  
  assertContextSatisfied(context);
  assertThat(testCase, passed());
}

- (void)testCanExpectNotificationWithSpecificSenderAndFail
{
  [context expectNotificationNamed:@"SomeTestNotification" fromObject:self];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"SomeTestNotification" object:@"some other object"];
  
  assertContextSatisfied(context);
  assertThat(testCase, failedWithNumberOfFailures(1));
}

@end
