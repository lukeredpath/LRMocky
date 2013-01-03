//
//  LRImposterizer.h
//  Mocky
//
//  Created by Luke Redpath on 03/01/2013.
//
//

#import "LRInvokable.h"

@protocol LRImposterizer <NSObject>

- (id)imposterizeClass:(Class)class invokable:(id<LRInvokable>)invokable ancilliaryProtocols:(NSArray *)protocols;
- (id)imposterizeProtocol:(Protocol *)protocol invokable:(id<LRInvokable>)invokable ancilliaryProtocols:(NSArray *)protocols;

@end
