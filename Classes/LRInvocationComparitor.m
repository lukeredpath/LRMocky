//
//  LRInvocationComparitor.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRInvocationComparitor.h"


@implementation LRInvocationComparitor

+ (id)comparitorForInvocation:(NSInvocation *)invocation;
{
  return [[[self alloc] initWithInvocation:invocation] autorelease];
}

- (id)initWithInvocation:(NSInvocation *)anInvocation;
{
  if (self = [super init]) {
    expectedInvocation = [anInvocation retain];
    [expectedInvocation retainArguments];
  }
  return self;
}

- (void)dealloc 
{
  [expectedInvocation release];
  [super dealloc];
}

- (BOOL)matchesParameters:(NSInvocation *)invocation;
{
  NSMethodSignature *methodSignature = [expectedInvocation methodSignature];
  
  BOOL matchesParameters = YES;
  for (int i = 2; i < [methodSignature numberOfArguments]; i++) {
    const char *argType = [methodSignature getArgumentTypeAtIndex:i];
    
    if (*argType == *@encode(id)) {
      id receivedArg;
      id expectedArg;
      
      [invocation getArgument:&receivedArg atIndex:i];
      [expectedInvocation getArgument:&expectedArg atIndex:i];
      
      matchesParameters = [receivedArg isEqual:expectedArg];
    } 
    else if(*argType == *@encode(int))
    {
      int receivedArg;
      int expectedArg;
      
      [invocation getArgument:&receivedArg atIndex:i];
      [expectedInvocation getArgument:&expectedArg atIndex:i];
      
      matchesParameters = (receivedArg == expectedArg);
    }
    else
    {
      NSLog(@"Unknown argType %c", *argType);
      matchesParameters = NO;
    }
  }
  return matchesParameters;
}

@end
