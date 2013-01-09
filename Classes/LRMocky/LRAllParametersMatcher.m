//
//  LRAllParametersMatcher.m
//  Mocky
//
//  Created by Luke Redpath on 05/01/2013.
//
//

#import "LRAllParametersMatcher.h"

#import <OCHamcrest/HCIsEqual.h>
#import <OCHamcrest/HCStringDescription.h>
#import <OCHamcrest/HCDescription.h>

@implementation LRAllParametersMatcher {
  NSArray *_parameterMatchers;
}

- (id)initWithParameters:(NSArray *)parameters
{
  if ((self = [super init])) {
    _parameterMatchers = [self matchersFrom:parameters];
  }
  return self;
}

- (void)describeTo:(id<HCDescription>)description
{
  if (_parameterMatchers.count == 0) return;
  
  NSMutableArray *descriptions = [NSMutableArray arrayWithCapacity:_parameterMatchers.count];
  
  for (id<HCMatcher> matcher in _parameterMatchers) {
    [descriptions addObject:[HCStringDescription stringFrom:matcher]];
  }
  
  [description appendText:[NSString stringWithFormat:@"with arguments: [%@] ", [descriptions componentsJoinedByString:@", "]]];
}

- (BOOL)matches:(id)item
{
  return [self matchesParameters:item];
}

- (BOOL)matchesParameters:(NSArray *)parameters
{
  BOOL result = YES;
  
  for (int i = 0; i < parameters.count; i++) {
    result &= [self matchesParameter:parameters[i] atIndex:i];
  }
  
  return result;
}

- (BOOL)matchesParameter:(id)parameter atIndex:(int)index
{
  if (parameter == NSNull.null) {
    parameter = nil;
  }
  return [_parameterMatchers[index] matches:parameter];
}

- (NSArray *)matchersFrom:(NSArray *)parameters
{
  NSMutableArray *matchers = [NSMutableArray arrayWithCapacity:parameters.count];
  
  for (id parameter in parameters) {
    if ([parameter conformsToProtocol:@protocol(HCMatcher)]) {
      [matchers addObject:parameter];
    }
    else {
      [matchers addObject:HC_equalTo(parameter)];
    }
  }
  return matchers;
}

@end
