//
//  LRMockySugar.h
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

// builder aliases for readability

#define it builder

// cardinality macros

#define oneOf(arg)    [builder oneOf:arg]
#define allowing(arg) [builder allowing:arg]