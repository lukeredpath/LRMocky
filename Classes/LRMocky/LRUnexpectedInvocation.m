//
//  LRUnexpectedInvocation.m
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRUnexpectedInvocation.h"
#import "NSInvocation+OCMAdditions.h"

#import <OCHamcrest/HCStringDescription.h>

@implementation LRUnexpectedInvocation

@synthesize action = _action;
@synthesize statePredicate = _statePredicate;
@synthesize invocation;
@synthesize mockObject;

+ (id)unexpectedInvocation:(NSInvocation *)invocation;
{
  return [[self alloc] initWithInvocation:invocation];
}

- (id)initWithInvocation:(NSInvocation *)anInvocation;
{
  if (self = [super init]) {
    invocation = anInvocation;
  }
  return self;
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
  HCStringDescription *description = [HCStringDescription stringDescription];
  [self describeTo:description];
  return [NSException exceptionWithName:LRMockyExpectationError reason:[description description] userInfo:nil];
}

- (void)describeTo:(id<HCDescription>)description
{
  NSMutableArray *arguments = [NSMutableArray array];
  for (int i = 2; i < [[invocation methodSignature] numberOfArguments]; i++) {
    id argument = [invocation getArgumentAtIndexAsObject:i];
    
    if (!argument) {
      argument = [NSNull null];
    }
    [arguments addObject:argument];
  }  
  [description appendText:[NSString stringWithFormat:@"Unexpected method %@ called on %@ with arguments: %@", 
      NSStringFromSelector([invocation selector]), mockObject, arguments]];
}

- (void)addAction:(id<LRExpectationAction>)action
{}

@end
