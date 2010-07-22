//
//  LRImposter.m
//  Mocky
//
//  Created by Luke Redpath on 22/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRImposter.h"


@implementation LRClassImposter

- (Class)classToImposterize
{
  [NSException raise:NSInternalInconsistencyException 
              format:@"Sub-classes of LRClassImposter must override classToImposterize"];
  return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
  return [[self classToImposterize] instanceMethodSignatureForSelector:sel];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
  return [[self classToImposterize] instancesRespondToSelector:aSelector];
}

@end


@implementation LRObjectImposter

- (id)objectToImposterize
{
  [NSException raise:NSInternalInconsistencyException 
              format:@"Sub-classes of LRObjectImposter must override objectToImposterize"];
  return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
  return [[self objectToImposterize] methodSignatureForSelector:sel];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
  return [[self objectToImposterize] respondsToSelector:aSelector];
}


@end

