//
//  LRPerformBlockArgumentAction.m
//  Mocky
//
//  Created by Luke Redpath on 30/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRPerformBlockArgumentAction.h"
#import "NSInvocation+OCMAdditions.h"

@implementation LRPerformBlockArgumentAction

- (void)invoke:(NSInvocation *)invocation
{
  for (int i = 0; i < [[invocation methodSignature] numberOfArguments]; i++) {
    if ([[invocation argumentDescriptionAtIndex:i] rangeOfString:@"Block__"].location != NSNotFound) {
      void *arg;
      [invocation getArgument:&arg atIndex:i];
      void (^block)() = (void (^)())arg;
      block();
    }
  } 
}

@end

LRPerformBlockArgumentAction *LRA_performBlockArguments()
{
  return [[[LRPerformBlockArgumentAction alloc] init] autorelease]; 
}
