//
//  LRReturnValueAction.h
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRExpectationAction.h"

@interface LRReturnValueAction : NSObject <LRExpectationAction>

- (id)initWithReturnValue:(id)returnValue;

@end
