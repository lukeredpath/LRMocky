//
//  LRActionSequence.m
//  Mocky
//
//  Created by Luke Redpath on 06/01/2013.
//
//

#import "LRActionSequence.h"
#import "LRReturnValueAction.h"
#import "LRPerformBlockAction.h"

@implementation LRActionSequence {
  NSMutableArray *_actions;
}

@synthesize actions = _actions;

+ (id)sequenceWithBlock:(void (^)(LRActionSequence *))sequenceBlock
{
  LRActionSequence *sequence = [[self alloc] init];
  sequenceBlock(sequence);
  return sequence;
}

- (id)init
{
  self = [super init];
  if (self) {
    _actions = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)returns:(id)returnValue
{
  [_actions addObject:[[LRReturnValueAction alloc] initWithReturnValue:returnValue]];
}

- (void)performBlock:(void (^)(NSInvocation *))block
{
  [_actions addObject:[[LRPerformBlockAction alloc] initWithBlock:block]];
}

@end
