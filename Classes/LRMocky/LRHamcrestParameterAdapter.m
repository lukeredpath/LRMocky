//
//  LRHamcrestParameter.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRHamcrestParameterAdapter.h"


@implementation LRHamcrestParameterAdapter

- (id)initWithMatcher:(id<HCMatcher>)aMatcher;
{
  if (self = [super init]) {
    matcher = [aMatcher retain];
  }
  return self;
}

- (void)dealloc 
{
  [matcher release];
  [super dealloc];
}

- (BOOL)isEqual:(id)object;
{
  return [matcher matches:object];
}

- (NSString *)description;
{
  return [matcher description];
}

@end

id LRM_with(id<HCMatcher> matcher)
{
  return [[[LRHamcrestParameterAdapter alloc] initWithMatcher:matcher] autorelease];  
}
