//
//  LRMockObject.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRMockObject.h"
#import "LRMockery.h"

@implementation LRMockObject

@synthesize mockedClass;

+ (id)mockForClass:(Class)aClass inContext:(LRMockery *)mockery;
{
  return [[[self alloc] initWithClass:aClass context:mockery] autorelease];
}

- (id)initWithClass:(Class)aClass context:(LRMockery *)mockery;
{
  if (self = [super init]) {
    mockedClass = aClass;
    context = [mockery retain];
  }
  return self;
}

- (void)dealloc;
{
  [context release];
  [super dealloc];
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
  [context dispatchInvocation:invocation];
}

@end
