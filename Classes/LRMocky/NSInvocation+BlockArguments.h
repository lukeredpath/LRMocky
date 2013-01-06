//
//  NSInvocation+BlockArguments.h
//  Mocky
//
//  Created by Luke Redpath on 06/01/2013.
//
//

#import <Foundation/Foundation.h>

@interface NSInvocation (BlockArguments)

- (void)copyBlockArguments;
- (void)releaseBlockArguments;

@end
