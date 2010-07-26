//
//  LRExpectationBuilder.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRExpectationBuilder.h"
#import "LRMockObject.h"
#import "LRMockery.h"
#import "LRInvocationExpectation.h"
#import "LRAllowingInvocation.h"

@interface LRExpectationBuilder ()
@property (nonatomic, retain) id<LRExpectation> currentExpecation;
- (void)actAsImposterForMockObject:(LRMockObject *)mock;
@end

@implementation LRExpectationBuilder

@synthesize currentExpecation;

+ (id)builderInContext:(LRMockery *)context;
{
  return [[[self alloc] initWithMockery:context] autorelease];
}

- (id)initWithMockery:(LRMockery *)aMockery;
{
  if (self = [super init]) {
    mockery = [aMockery retain];
  }
  return self;
}

- (Class)classToImposterize
{
  return mockedClass;
}

- (void)dealloc;
{
  [mockery release];
  [super dealloc];
}

- (id)oneOf:(id)mockObject;
{
  self.currentExpecation = [LRInvocationExpectation expectation];
  
  [self actAsImposterForMockObject:mockObject];
  return self;
}

- (id)allowing:(id)mockObject;
{
  self.currentExpecation = [LRAllowingInvocation expectation];
  
  [self actAsImposterForMockObject:mockObject];
  return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
  self.currentExpecation.invocation = invocation;
  [mockery addExpectation:self.currentExpecation];
}

- (id)will:(id<LRExpectationAction>)action;
{
  [self.currentExpecation addAction:action];
  return self;
}

#pragma mark Private methods

- (void)actAsImposterForMockObject:(LRMockObject *)mock;
{
  mockedClass = [mock mockedClass];
}

@end
