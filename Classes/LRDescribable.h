//
//  HCSelfDescribing.h
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

@class LRExpectationMessage;

@protocol HCSelfDescribing <NSObject>

- (void)describeTo:(id<HCDescription>)description;

@end
