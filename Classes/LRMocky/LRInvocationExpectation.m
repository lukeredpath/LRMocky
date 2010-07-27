//
//  LRInvocationExpectation.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRInvocationExpectation.h"
#import "LRInvocationComparitor.h"

@implementation LRInvocationExpectation

@synthesize invocation = expectedInvocation;
@synthesize cardinality;

+ (id)expectation;
{
  return [[[self alloc] init] autorelease];
}

- (id)init;
{
  if (self = [super init]) {
    numberOfInvocations = 0;
    actions = [[NSMutableArray alloc] init];
    self.cardinality = LRM_expectExactly(1); // TODO choose a better default
  }
  return self;
}

- (void)dealloc;
{
  [actions release];
  [expectedInvocation release];
  [super dealloc];
}

- (BOOL)matches:(NSInvocation *)invocation;
{
  if ([invocation selector] != [expectedInvocation selector]) {
    return NO;
  }  
  return YES;
}

- (void)invoke:(NSInvocation *)invocation
{
  LRInvocationComparitor *comparitor = [LRInvocationComparitor comparitorForInvocation:expectedInvocation];
  
  if([comparitor matchesParameters:invocation]) {
    numberOfInvocations++;
    
    for (id<LRExpectationAction> action in actions) {
      [action invoke:invocation];
    } 
  }
}

- (BOOL)isSatisfied;
{
  return [self.cardinality satisfiedBy:numberOfInvocations];
}

- (NSException *)failureException;
{
  return [NSException exceptionWithName:@"test failure" reason:@"just testing" userInfo:nil];
}

- (void)addAction:(id<LRExpectationAction>)anAction;
{
  [actions addObject:anAction];
}

@end

@implementation LREqualToCardinality

- (id)initWithInt:(int)anInt;
{
  if (self = [super init]) {
    equalToInt = anInt;
  }
  return self;
}

- (BOOL)satisfiedBy:(int)numberOfInvocations
{
  return numberOfInvocations == equalToInt;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"equalTo(%d)", equalToInt];
}

@end

id<LRExpectationCardinality> LRM_expectExactly(int anInt)
{
  return [[[LREqualToCardinality alloc] initWithInt:anInt] autorelease];
}

@implementation LRAtLeastCardinality

- (id)initWithMinimum:(int)theMinimum;
{
  if (self = [super init]) {
    minimum = theMinimum;
  }
  return self;
}

- (BOOL)satisfiedBy:(int)numberOfInvocations
{
  return numberOfInvocations >= minimum;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"atLeast(%d)", minimum];
}

@end

id<LRExpectationCardinality> LRM_atLeast(int anInt)
{
  return [[[LRAtLeastCardinality alloc] initWithMinimum:anInt] autorelease];
}

@implementation LRAtMostCardinality

- (id)initWithMaximum:(int)theMaximum;
{
  if (self = [super init]) {
    maximum = theMaximum;
  }
  return self;
}

- (BOOL)satisfiedBy:(int)numberOfInvocations
{
  return numberOfInvocations <= maximum;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"atMost(%d)", maximum];
}

@end

id<LRExpectationCardinality> LRM_atMost(int anInt)
{
  return [[[LRAtMostCardinality alloc] initWithMaximum:anInt] autorelease];
}

@implementation LRBetweenCardinality

- (id)initWithMinimum:(int)theMinimum andMaximum:(int)theMaximum;
{
  if (self = [super init]) {
    minimum = theMinimum;
    maximum = theMaximum;
  }
  return self;
}

- (BOOL)satisfiedBy:(int)numberOfInvocations
{
  return (numberOfInvocations >= minimum && numberOfInvocations <= maximum);
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"between(%d and %d)", minimum, maximum];
}

@end

id<LRExpectationCardinality> LRM_between(int min, int max)
{
  return [[[LRBetweenCardinality alloc] initWithMinimum:min andMaximum:max] autorelease];
}

@implementation LRNeverCardinality

- (BOOL)satisfiedBy:(int)numberOfInvocations
{
  return numberOfInvocations == 0;
}

- (NSString *)description
{
  return @"never";
}

@end

id<LRExpectationCardinality> LRM_never()
{
  return [[[LRNeverCardinality alloc] init] autorelease];
}

@implementation LRAllowingCardinality

- (BOOL)satisfiedBy:(int)numberOfInvocations
{
  return YES;
}

- (NSString *)description
{
  return @"any number of times";
}

@end

id<LRExpectationCardinality> LRM_allowing()
{
  return [[[LRAllowingCardinality alloc] init] autorelease];
}
