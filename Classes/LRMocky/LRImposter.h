//
//  LRImposter.h
//  Mocky
//
//  Created by Luke Redpath on 22/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRImposterizer;

@interface LRImposter : NSObject
{
  LRImposterizer *imposterizer;
}
@property (nonatomic, retain) LRImposterizer *imposterizer;

- (id)initWithImposterizer:(LRImposterizer *)anImposterizer;
@end
