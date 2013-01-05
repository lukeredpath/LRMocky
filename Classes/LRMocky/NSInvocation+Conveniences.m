//
//  NSInvocation+Conveniences.m
//  Mocky
//
//  Created by Luke Redpath on 05/01/2013.
//
//

#import "NSInvocation+Conveniences.h"
#import "NSInvocation+OCMAdditions.h"

const NSUInteger NSMethodSignatureArgumentsToIgnore = 2;

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

- (NSUInteger)numberOfActualArguments
{
  return self.methodSignature.numberOfArguments - NSMethodSignatureArgumentsToIgnore;
}

- (void)putObject:(id)object asArgumentAtIndex:(NSUInteger)index
{
  [self setArgument:&object atIndex:index + NSMethodSignatureArgumentsToIgnore];
}

@end
