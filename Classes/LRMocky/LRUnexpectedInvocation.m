//
//  LRUnexpectedInvocation.m
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRUnexpectedInvocation.h"
#import "LRExpectationMessage.h"

@implementation LRUnexpectedInvocation

@synthesize invocation;
@synthesize mockObject;

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
  [mockObject release];
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

- (NSException *)failureException;
{
  LRExpectationMessage *errorMessage = [[[LRExpectationMessage alloc] init] autorelease];
  [self describeTo:errorMessage];
  return [NSException exceptionWithName:LRMockyExpectationError reason:errorMessage.message userInfo:nil];
}

- (void)describeTo:(LRExpectationMessage *)message
{
  [message append:[NSString stringWithFormat:@"Unexpected method %@ called on %@", NSStringFromSelector([invocation selector]), mockObject]];
}

- (void)addAction:(id<LRExpectationAction>)action
{}

@end
