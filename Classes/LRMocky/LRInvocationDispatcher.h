//
//  LRInvocationDispatcher.h
//  Mocky
//
//  Created by Luke Redpath on 03/01/2013.
//
//

@protocol LRInvocationDispatcher <NSObject>

- (void)dispatch:(NSInvocation *)invocation;

@end
