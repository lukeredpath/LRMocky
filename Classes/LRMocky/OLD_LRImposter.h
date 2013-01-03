//
//  LRImposter.h
//  Mocky
//
//  Created by Luke Redpath on 22/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLD_LRImposterizer.h"

@interface OLD_LRImposter : NSObject <LRImposterizerDelegate>
{
  OLD_LRImposterizer *imposterizer;
}
@property (nonatomic, retain) OLD_LRImposterizer *imposterizer;

- (id)initWithImposterizer:(OLD_LRImposterizer *)anImposterizer;
@end
