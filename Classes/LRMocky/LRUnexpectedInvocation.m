//
//  LRUnexpectedInvocation.m
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRUnexpectedInvocation.h"


@implementation LRUnexpectedInvocation

@synthesize invocation;

+ (id)unexpectedInvocation:(NSInvocation *)invocation;
{
  return [[[self alloc] initWithInvocation:invocation] autorelease];
}

- (id)initWithInvocation:(NSInvocation *)anInvocation;
{
  if (self = [super init]) {
    invocation = [anInvocation retain];
  }
  return self;
}

- (void)dealloc;
{
  [invocation release];
  [super dealloc];
}

- (void)invoke:(NSInvocation *)invocation
{}

- (BOOL)matches:(NSInvocation *)invocation
{
  return NO;
}

- (BOOL)isSatisfied
{
  return NO;
}

- (NSException *)failureException
{
  return [NSException exceptionWithName:@"UnexpectedInvocation" reason:@"Unexpected invocation" userInfo:nil];
}

- (void)addAction:(id<LRExpectationAction>)action
{}

@end
