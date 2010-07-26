//
//  LRImposter.h
//  Mocky
//
//  Created by Luke Redpath on 22/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol LRImposter
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel;
- (BOOL)respondsToSelector:(SEL)aSelector;
@optional
// override to actually do something with an invocation
- (void)forwardInvocation:(NSInvocation *)anInvocation;
@end

@interface LRClassImposter : NSObject
{}
- (Class)classToImposterize; // template method
@end

@interface LRObjectImposter : NSObject
{}
- (id)objectToImposterize;  // template method
@end

