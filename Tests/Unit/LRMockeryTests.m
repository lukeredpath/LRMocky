//
//  LRMockeryTests.m
//  Mocky
//
//  Created by Luke Redpath on 07/01/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "TestHelper.h"
#import "LRMockery.h"
#import "LRMockObject.h"

@interface FakeTestNotifier : NSObject <LRTestCaseNotifier>

@end

@implementation FakeTestNotifier

- (void)notifiesFailureWithDescription:(NSString *)description inFile:(NSString *)fileName lineNumber:(int)lineNumber
{}

@end

DEFINE_TEST_CASE(LRMockeryTests) {
  LRMockery *mockery;
  FakeTestNotifier *notifier;
}

- (void)setUp
{
  notifier = [[FakeTestNotifier alloc] init];
  mockery = [[LRMockery alloc] initWithNotifier:notifier];
}

- (void)testReturnsMockObjectsForClassWithDescriptiveName
{
  id mockObject = [mockery mock:[NSObject class] named:@"my mock"];

  assertThat([mockObject description], equalTo(@"my mock"));
}

- (void)testReturnsMockObjectsForProtocolWithDescriptiveName
{
  id mockObject = [mockery mock:@protocol(NSObject) named:@"my mock"];
  
  assertThat([mockObject description], equalTo(@"my mock"));
}

- (void)testReturnsMockObjectsForClassWithDefaultName
{
  id mockObject = [mockery mock:[NSObject class]];
  
  assertThat([mockObject description], equalTo(@"<mock NSObject>"));
}

- (void)testReturnsMockObjectsForProtocolWithDefaultName
{
  id mockObject = [mockery mock:@protocol(NSObject)];
  
  assertThat([mockObject description], equalTo(@"<mock NSObject>"));
}

- (void)testRaisesExceptionIfTryingToMockObjectInstance
{
  assertThat(^{ [mockery mock:@"an object"]; }, raisesExceptionWithType(NSInternalInconsistencyException));
}

END_TEST_CASE
