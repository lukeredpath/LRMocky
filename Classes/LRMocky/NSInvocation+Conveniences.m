//
//  NSInvocation+Conveniences.m
//  Mocky
//
//  Created by Luke Redpath on 05/01/2013.
//
//

#import "NSInvocation+Conveniences.h"
#import "NSInvocation+OCMAdditions.h"

@implementation NSInvocation (Conveniences)

- (NSArray *)argumentsArray
{
  NSUInteger argumentCount = [self.methodSignature numberOfArguments];
  NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:argumentCount];
  
  for (int i = 2; i < argumentCount; i++) {
    [arguments addObject:[self getArgumentAtIndexAsObject:i]];
  }
  return [arguments copy];
}

@end
