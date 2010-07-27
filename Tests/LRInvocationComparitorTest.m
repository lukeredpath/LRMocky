//
//  LRInvocationComparitorTest.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "LRInvocationComparitor.h"
#import "LRImposter.h"
#define LRMOCKY_SHORTHAND
#import "LRHamcrestParameterAdapter.h"

@interface InvocationTesterObject : NSObject
- (id)takesAnObject:(id)object;
- (id)takesAnInt:(int)anInt;
@end

@implementation InvocationTesterObject

- (id)takesAnObject:(id)object { return nil; }
- (id)takesAnInt:(int)anInt { return nil; }
- (id)takesAFloat:(float)aFloat { return nil; }

@end

@interface InvocationCapturer : LRClassImposter
{
  NSInvocation *lastInvocation;
}
@property (nonatomic, readonly) NSInvocation *invocation;
@end

@implementation InvocationCapturer

@synthesize invocation = lastInvocation;

- (Class)classToImposterize
{
  return [InvocationTesterObject class];
}

- (void)forwardInvocation:(NSInvocation *)invocation;
{
  [lastInvocation release];
  [invocation retainArguments];
  [invocation setReturnValue:&self];
  lastInvocation = [invocation retain];
}

@end

@interface LRInvocationComparitorTest : SenTestCase
{
  InvocationTesterObject *testObject;
  id capture;
}
@end

@implementation LRInvocationComparitorTest

- (void)setUp;
{
  testObject = [[InvocationTesterObject alloc] init];
  capture = [[InvocationCapturer alloc] init];
}

- (void)testCanCompareObjectMethodParameters
{
  NSInvocation *expected = [[capture takesAnObject:@"foo"] invocation];
  LRInvocationComparitor *comparitor = [LRInvocationComparitor comparitorForInvocation:expected];
  
  assertThatBool([comparitor matchesParameters:[[capture takesAnObject:@"foo"] invocation]], 
                 equalToBool(YES));

  assertThatBool([comparitor matchesParameters:[[capture takesAnObject:@"bar"] invocation]], 
                 equalToBool(NO));
}

- (void)testCanCompareIntegerParameters
{
  NSInvocation *expected = [[capture takesAnInt:10] invocation];
  LRInvocationComparitor *comparitor = [LRInvocationComparitor comparitorForInvocation:expected];
  
  assertThatBool([comparitor matchesParameters:[[capture takesAnInt:10] invocation]], 
                 equalToBool(YES));
  
  assertThatBool([comparitor matchesParameters:[[capture takesAnInt:20] invocation]], 
                 equalToBool(NO));
}

- (void)testCanCompareFloatParameters
{
  NSInvocation *expected = [[capture takesAFloat:3.14] invocation];
  LRInvocationComparitor *comparitor = [LRInvocationComparitor comparitorForInvocation:expected];
  
  assertThatBool([comparitor matchesParameters:[[capture takesAFloat:3.14] invocation]], 
                 equalToBool(YES));
  
  assertThatBool([comparitor matchesParameters:[[capture takesAFloat:10.45] invocation]], 
                 equalToBool(NO));
}

- (void)testCanCompareParametersThatUseMatchers
{
  NSInvocation *expected = [[capture takesAnObject:with(hasItem(@"foo"))] invocation];
  LRInvocationComparitor *comparitor = [LRInvocationComparitor comparitorForInvocation:expected];
  
  assertThatBool([comparitor matchesParameters:[[capture takesAnObject:[NSArray arrayWithObject:@"foo"]] invocation]], 
                 equalToBool(YES));
  
  assertThatBool([comparitor matchesParameters:[[capture takesAnObject:[NSArray arrayWithObject:@"bar"]] invocation]], 
                 equalToBool(NO));
}

@end
