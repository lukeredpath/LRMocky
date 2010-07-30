//
//  StateMachineTests.m
//  Mocky
//
//  Created by Luke Redpath on 30/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "FunctionalMockeryTestCase.h"

@interface Day : NSObject
- (void)becomeMorning;
- (void)becomeEvening;
@end;

@implementation Day
- (void)becomeMorning {}
- (void)becomeEvening {}
@end

@interface DayManipulator : NSObject
{
  Day *theDay;
}
- (id)initWithDay:(Day *)day;
- (void)manipulateDayProperly;
- (void)manipulateDayInReverse;
@end

@implementation DayManipulator

- (id)initWithDay:(Day *)day;
{
  if (self = [super init]) {
    theDay = [day retain];
  }
  return self;
}

- (void)dealloc;
{
  [theDay release];
  [super dealloc];
}

- (void)manipulateDayProperly;
{
  [theDay becomeMorning];
  [theDay becomeEvening];
}

- (void)manipulateDayInReverse;
{
  [theDay becomeEvening];
  [theDay becomeMorning];
}

@end

@interface StateMachineTests : FunctionalMockeryTestCase
@end

@implementation StateMachineTests

- (void)testCanExpectCallWhenInAParticularStateAndPass
{
  LRMockyStates *sun = [context states:@"Sun"];
  
  id day = [context mock:[Day class]];
  
  [context checking:^(that){
    [oneOf(day) becomeMorning]; then([sun becomes:@"risen"]);
    [oneOf(day) becomeEvening]; when([sun inState:@"risen"]);
  }];
  
  DayManipulator *manipulator = [[DayManipulator alloc] initWithDay:day];
  [manipulator manipulateDayProperly];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanExpectCallWhenInAParticularStateAndFail
{
  LRMockyStates *sun = [context states:@"Sun"];
  
  id day = [context mock:[Day class]];
  
  [context checking:^(that){
    [oneOf(day) becomeMorning]; then([sun becomes:@"risen"]);
    [oneOf(day) becomeEvening]; when([sun inState:@"risen"]);
  }];
  
  DayManipulator *manipulator = [[DayManipulator alloc] initWithDay:day];
  [manipulator manipulateDayInReverse];
  
  [context assertSatisfied];
  
  assertThat(testCase, failedWithNumberOfFailures(2));
}

@end
