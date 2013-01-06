//
//  LRConsecutiveCallAction.h
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRExpectationAction.h"

@interface LRConsecutiveCallAction : NSObject <LRExpectationAction>

- (id)initWithActions:(NSArray *)actionList;

@end
