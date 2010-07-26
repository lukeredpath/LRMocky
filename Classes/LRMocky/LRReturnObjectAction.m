//
//  LRReturnObjectAction.m
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRReturnObjectAction.h"


@implementation LRReturnObjectAction

- (id)initWithObject:(id)object;
{
  if (self = [super init]) {
    objectToReturn = [object retain];
  }
  return self;
}

- (void)dealloc 
{
  [objectToReturn release];
  [super dealloc];
}

- (void)invoke:(NSInvocation *)invocation;
{
  [invocation setReturnValue:&objectToReturn];
}

@end

LRReturnObjectAction *LRA_returnObject(id object) {
  return [[[LRReturnObjectAction alloc] initWithObject:object] autorelease];
}
