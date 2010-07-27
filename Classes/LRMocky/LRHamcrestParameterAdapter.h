//
//  LRHamcrestParameter.h
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCMatcher.h"


@interface LRHamcrestParameterAdapter : NSObject {
  id<HCMatcher> matcher;
}
- (id)initWithMatcher:(id<HCMatcher>)aMatcher;
@end

id LRM_with(id<HCMatcher> matcher);

#ifdef LRMOCKY_SHORTHAND
#define with LRM_with
#endif
