//
//  ExpectationActionsTest.m
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "FunctionalMockeryTestCase.h"

DEFINE_FUNCTIONAL_TEST_CASE(ExpectationActionsTest)

- (void)testMocksCanReturnAnObjectFromAnExpectedInvocation;
{
  NSString *expectedObject = @"some string";
  
  [context check:^{
    [[expectThat(testObject) receives] returnSomething]; [and then:returnObject(expectedObject)];
  }];
  
  assertThat([testObject returnSomething], equalTo(expectedObject));
}

- (void)testMocksCanReturnAnObjectFromAnAllowedInvocation;
{
  NSString *expectedObject = @"some string";
  
  [context check:^{
    [allowing(testObject) returnSomething]; [and then:returnObject(expectedObject)];
  }];
  
  assertThat([testObject returnSomething], equalTo(expectedObject));
}

- (void)testMocksCanCallBlocksFromAnExpectedInvocation;
{
  NSMutableArray *someArray = [NSMutableArray array];
  
  [context check:^{
    [[expectThat(testObject) receives] doSomething]; [and then:performBlock(^(NSInvocation *invocation) {
      [someArray addObject: NSStringFromSelector([invocation selector])];
    })];
  }];
  
  [testObject doSomething];
  
  assertThat(someArray, hasItem(@"doSomething"));
}

- (void)testMocksCanCallBlocksFromAnAllowedInvocation;
{
  NSMutableArray *someArray = [NSMutableArray array];
  
  [context check:^{
    [[expectThat(testObject) receives] doSomething]; [and then:performBlock(^(NSInvocation *invocation) {
      [someArray addObject: NSStringFromSelector([invocation selector])];
    })];
  }];
  
  [testObject doSomething];
  
  assertThat(someArray, hasItem(@"doSomething"));
}

- (void)testMocksCanReturnANonObjectValueFromAnExpectedInvocation;
{
  [context check:^{
    [[expectThat(testObject) receives] returnSomeValue]; [and then:returnInt(10)];
  }];
  
  assertThatInt((int)[testObject returnSomeValue], equalToInt(10));
}

- (void)testMocksCanReturnANonObjectValueFromAnAllowedInvocation;
{
  [context check:^{
    [allowing(testObject) returnSomeValue]; [and then:returnInt(20)];
  }];
  
  assertThatInt((int)[testObject returnSomeValue], equalToInt(20));
}

- (void)testMocksCanReturnDifferentValuesOnConsecutiveCalls;
{
  [context check:^{
    [[[expectThat(testObject) receives:atLeast(3)] of] returnSomeValue]; [and then:onConsecutiveCalls(
      returnInt(10),
      returnInt(20),
      returnInt(30),                                       
     nil)];
  }];
  
  assertThatInt((int)[testObject returnSomeValue], equalToInt(10));
  assertThatInt((int)[testObject returnSomeValue], equalToInt(20));
  assertThatInt((int)[testObject returnSomeValue], equalToInt(30));
  assertThatInt((int)[testObject returnSomeValue], equalToInt(30));
}

- (void)xtestCanExpectMethodCallsWithBlockArgumentsAndCallTheSuppliedBlock;
{
  id mockArray = [context mock:[NSArray class]];
  
  __block NSString *someString = nil;
  
  [context check:^{
    [[expectThat(mockArray) receives] indexesOfObjectsPassingTest:(__bridge BOOL (^)(__strong id, NSUInteger, BOOL *))(anyBlock())]; [and then:performBlockArguments];
  }];
  
  [(NSArray *)mockArray indexesOfObjectsPassingTest:^(id object, NSUInteger idx, BOOL *stop) { 
    someString = @"some string";
    return YES; 
  }];
  
  assertThat(someString, equalTo(@"some string"));
}

#if !(TARGET_IPHONE_SIMULATOR)
- (void)testMocksCanThrowAnException;
{
  [context check:^{
    [allowing(testObject) doSomething]; [and then:throwException([NSException exceptionWithName:@"Test Exception" reason:nil userInfo:nil])];
  }];
  
  /**
   * this will only pass using the iOS 4.0 Device SDK, it currently fails
   * with the simulator SDK due to a runtime bug. rdar://8081169
   * also see: http://openradar.appspot.com/8081169
   * filed dupe: http://openradar.appspot.com/
   */
  
  @try {
    [testObject doSomething];
    STFail(@"Exception expected but none was thrown");
  }
  @catch (NSException *exception) {
    assertThat([exception name], equalTo(@"Test Exception"));
  }
}
#endif

- (void)testMocksCanPerformMultipleActions;
{
  NSMutableArray *array = [NSMutableArray array];

  [context check:^{
    [allowing(testObject) returnSomething]; [and then:doAll(
      returnObject(@"test"),
      performBlock(^(NSInvocation *invocation){ 
        [array addObject:@"from block"];
      }), 
    nil)];
  }];
  
  assertThat([testObject returnSomething], equalTo(@"test"));
  assertThat(array, hasItem(@"from block"));
}

END_TEST_CASE
