//
//  LRExpectationActionSyntax.h
//  Mocky
//
//  Created by Luke Redpath on 06/01/2013.
//
//

#import <Foundation/Foundation.h>

@protocol LRExpectationActionSyntax <NSObject>

- (void)returns:(id)returnObject;
- (void)performBlock:(void (^)(NSInvocation *))block;

@end
