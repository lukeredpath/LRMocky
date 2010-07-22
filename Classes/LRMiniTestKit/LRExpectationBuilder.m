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

@implementation LRExpectationBuilder

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

- (void)dealloc;
{
  [mockery release];
  [super dealloc];
}

- (id)expect:(id)mockObject;
{
  mockedClass = [(LRMockObject *)mockObject mockedClass];
  return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
  return [mockedClass instanceMethodSignatureForSelector:sel];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
  return [mockedClass instancesRespondToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
  [mockery addExpectation:[LRInvocationExpectation expectationWithInvocation:invocation]];
}

@end
