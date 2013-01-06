//
//  LRCompositeAction.m
//  Mocky
//
//  Created by Luke Redpath on 06/01/2013.
//
//

#import "LRCompositeAction.h"

@implementation LRCompositeAction {
  NSMutableArray *_actions;
}

- (id)init
{
  if (self = [super init]) {
    _actions = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)addAction:(id<LRExpectationAction>)action
{
  [_actions addObject:action];
}

- (void)invoke:(NSInvocation *)invocation
{
  for (id<LRExpectationAction> action in _actions) {
    [action invoke:invocation];
  }
}

@end
