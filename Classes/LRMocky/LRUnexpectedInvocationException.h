//
//  LRUnexpectedInvocationException.h
//  Mocky
//
//  Created by Luke Redpath on 03/01/2013.
//
//

#import <Foundation/Foundation.h>

extern NSString *const LRUnexpectedInvocationInvocationUserInfoKey;

@interface LRUnexpectedInvocationException : NSException

+ (id)exceptionWithInvocation:(NSInvocation *)invocation;

@end
