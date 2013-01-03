//
//  LRInvokable.h
//  Mocky
//
//  Created by Luke Redpath on 03/01/2013.
//
//

#import <Foundation/Foundation.h>

@protocol LRInvokable <NSObject>

- (void)invoke:(NSInvocation *)invocation;

@end
