//
//  LRReturnObjectAction.h
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRExpectationAction.h"

@interface LRReturnObjectAction : NSObject <LRExpectationAction> {
  id objectToReturn;
}
- (id)initWithObject:(id)object;
@end

LRReturnObjectAction *LRA_returnObject(id object);

#ifdef LRMOCKY_SHORTHAND
#define returnObject LRA_returnObject
#endif
