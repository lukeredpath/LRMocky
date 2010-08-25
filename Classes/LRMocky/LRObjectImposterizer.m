//
//  LRObjectImposterizer.m
//  Mocky
//
//  Created by Luke Redpath on 24/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRObjectImposterizer.h"


@implementation LRObjectImposterizer

- (id)initWithObject:(id)object;
{
  if (self = [super init]) {
    objectToImposterize = [object retain];
  }
  return self;
}

- (void)dealloc
{
  [objectToImposterize release];
  [super dealloc];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
  return [objectToImposterize methodSignatureForSelector:sel];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
  return [objectToImposterize respondsToSelector:aSelector];
}

- (LRImposterizer *)matchingImposterizer;
{
  return [[[LRObjectImposterizer alloc] initWithObject:objectToImposterize] autorelease];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"forObject:%@", objectToImposterize];
}

@end
