//
//  LRInvocationComparitorTest.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "LRInvocationComparitor.h"
#import "LRReflectionImposterizer.h"

@interface InvocationTesterObject : NSObject
- (id)takesAnObject:(id)object;
- (id)takesAnInt:(int)anInt;
@end

@implementation InvocationTesterObject

- (id)takesAnObject:(id)object { return nil; }
- (id)takesAnInt:(int)anInt { return nil; }
- (id)takesAFloat:(float)aFloat { return nil; }

@end

DEFINE_TEST_CASE(LRInvocationComparitorTest) {
  InvocationTesterObject *testObject;
  id capture;
}

- (void)setUp;
{
  testObject = [[InvocationTesterObject alloc] init];
  
  LRReflectionImposterizer *imposterizer = [[LRReflectionImposterizer alloc] init];

  capture = [imposterizer imposterizeClass:[InvocationTesterObject class] invokable:[[CapturesInvocations alloc] init] ancilliaryProtocols:nil];
}

- (void)testSanity
{
  assertThat([[capture takesAnObject:@"bar"] lastInvocation], isNot(nilValue()));
  assertThat([[capture takesAnObject:@"bar"] lastInvocation], isNot(equalTo([[capture takesAnObject:@"foo"] invocation])));
}

- (void)testCanCompareObjectMethodParameters
{
  NSInvocation *expected = [[capture takesAnObject:@"foo"] invocation];
  LRInvocationComparitor *comparitor = [LRInvocationComparitor comparitorForInvocation:expected];
  
  assertTrue([comparitor matchesParameters:[[capture takesAnObject:@"foo"] invocation]]);
  assertFalse([comparitor matchesParameters:[[capture takesAnObject:@"bar"] invocation]]);
}

- (void)testCanCompareIntegerParameters
{
  NSInvocation *expected = [[capture takesAnInt:10] invocation];
  LRInvocationComparitor *comparitor = [LRInvocationComparitor comparitorForInvocation:expected];
  
  assertTrue([comparitor matchesParameters:[[capture takesAnInt:10] invocation]]);
  assertFalse([comparitor matchesParameters:[[capture takesAnInt:20] invocation]]);
}

- (void)testCanCompareFloatParameters
{
  NSInvocation *expected = [[capture takesAFloat:3.14] invocation];
  LRInvocationComparitor *comparitor = [LRInvocationComparitor comparitorForInvocation:expected];
  
  assertTrue([comparitor matchesParameters:[[capture takesAFloat:3.14] invocation]]);
  assertFalse([comparitor matchesParameters:[[capture takesAFloat:10.45] invocation]]);
}

- (void)testCanCompareParametersThatUseObjectMatchers
{
  NSInvocation *expected = [[capture takesAnObject:hasItem(@"foo")] invocation];
  LRInvocationComparitor *comparitor = [LRInvocationComparitor comparitorForInvocation:expected];
  
  assertTrue([comparitor matchesParameters:[[capture takesAnObject:[NSArray arrayWithObject:@"foo"]] invocation]]);
  assertFalse([comparitor matchesParameters:[[capture takesAnObject:[NSArray arrayWithObject:@"bar"]] invocation]]);
}

END_TEST_CASE
