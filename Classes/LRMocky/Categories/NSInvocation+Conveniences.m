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

- (void)setReturnValueFromObject:(id)object
{
  const char* returnType = [self.methodSignature methodReturnType];
  
  switch (returnType[0]) {
    case '#':
    case '@':
      [self setReturnValue:&object];
      break;
    case 'i':
		{
			int value = [object intValue];
      [self setReturnValue:&value];
      break;
		}
// TODO: support remaining values, but implement with unit test coverage instead of acceptance test coverage
//
//		case 's':
//		{
//			short value;
//		}
//		case 'l':
//		{
//			long value;
//		}
//		case 'q':
//		{
//			long long value;
//		}
//		case 'c':
//		{
//			char value;
//		}
//		case 'C':
//		{
//			unsigned char value;
//		}
//		case 'I':
//		{
//			unsigned int value;
//		}
//		case 'S':
//		{
//			unsigned short value;
//		}
//		case 'L':
//		{
//			unsigned long value;
//		}
//		case 'Q':
//		{
//			unsigned long long value;
//		}
//		case 'f':
//		{
//			float value;
//		}
//		case 'd':
//		{
//			double value;
//		}
//		case 'B':
//		{
//			bool value;
//		}
    default:
      @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"Unable to set return value of %@ for invocation with signature %@.", object, [self.methodSignature debugDescription]] userInfo:nil];
      break;
  }
}

@end
