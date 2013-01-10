//
//  LRSynchroniser.m
//  Mocky
//
//  Created by Luke Redpath on 10/01/2013.
//
//

#import "LRSynchroniser.h"

@implementation LRSynchroniser {
  NSTimeInterval _timeout;
}

+ (id)synchroniser
{
  return [[self alloc] initWithTimeout:5];
}

+ (id)synchroniserWithTimeout:(NSTimeInterval)timeout
{
  return [[self alloc] initWithTimeout:timeout];
}

- (id)initWithTimeout:(NSTimeInterval)timeout
{
  self = [super init];
  if (self) {
    _timeout = timeout;
  }
  return self;
}

- (void)waitUntil:(id<LRStatePredicate>)statePredicate
{
  if ([statePredicate isActive]) return;
  
  NSDate *waitUntil = [NSDate dateWithTimeIntervalSinceNow:_timeout];
  
  BOOL predicateSatisfied = NO;
  NSInteger pollingInterval = 0.1;
  
  while (!predicateSatisfied) {
    NSDate *runUntil = [NSDate dateWithTimeIntervalSinceNow:pollingInterval];
    
    if ([runUntil earlierDate:waitUntil] == waitUntil) {
      break;
    }
    [[NSRunLoop currentRunLoop] runUntilDate:runUntil];
    
    predicateSatisfied = [statePredicate isActive];
  }
}

@end
