//
//  LRExpectationProxy.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRExpectationProxy.h"
#import "LRInvocationExpectation.h"

@implementation LRExpectationProxy

+ (id)proxyForClass:(Class)aClass;
{
  return [[[self alloc] initWithClass:aClass] autorelease];
}

- (id)initWithClass:(Class)aClass;
{
  proxiedClass = aClass;
  expectations = [[NSMutableArray alloc] init];
  
  return self;
}

- (void)dealloc;
{
  [expectations release];
  [super dealloc];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
  return [proxiedClass instanceMethodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
  [expectations addObject:[LRInvocationExpectation expectationWithInvocation:invocation]];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
  return [proxiedClass instancesRespondToSelector:aSelector];
}

- (BOOL)hasExpectationMatchingInvocation:(NSInvocation *)invocation;
{
  for (LRInvocationExpectation *expectation in expectations) {
    if ([expectation matches:invocation]) return YES;
  }
  return NO;
}

@end
