//
//  NSInvocation+BlockArguments.m
//  Mocky
//
//  Created by Luke Redpath on 06/01/2013.
//
//

#import "NSInvocation+BlockArguments.h"
#import "NSInvocation+OCMAdditions.h"

@implementation NSInvocation (BlockArguments)

- (void)copyBlockArguments;
{
  for (int i = 2; i < [[self methodSignature] numberOfArguments]; i++) {
    if ([[self argumentDescriptionAtIndex:i] rangeOfString:@"Block"].location != NSNotFound) {
      void *arg;
      [self getArgument:&arg atIndex:i];
      void (^block)() = (void (^)())arg;
      [block copy];
    }
  }
}

- (void)releaseBlockArguments;
{
  for (int i = 2; i < [[self methodSignature] numberOfArguments]; i++) {
    if ([[self argumentDescriptionAtIndex:i] rangeOfString:@"Block"].location != NSNotFound) {
      void *arg;
      [self getArgument:&arg atIndex:i];
      void (^block)() = (void (^)())arg;
      [block release];
    }
  }
}

@end
