//
//  LRImposterizer.m
//  Mocky
//
//  Created by Luke Redpath on 24/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "OLD_LRImposterizer.h"


@implementation OLD_LRImposterizer

@synthesize delegate;

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
  if ([self.delegate shouldActAsImposterForInvocation:anInvocation]) {
    [self.delegate handleImposterizedInvocation:anInvocation];
  }
}

- (OLD_LRImposterizer *)matchingImposterizer;
{
  @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must overide matchingImposterizer in subclass" userInfo:nil];
}

@end
