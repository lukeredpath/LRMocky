//
//  LRImposterizable.h
//  Mocky
//
//  Created by Luke Redpath on 07/01/2013.
//
//

#import <Foundation/Foundation.h>

@protocol LRImposterizable <NSObject>

- (id)imposterizeTo:(id<LRInvokable>)invokable ancilliaryProtocols:(NSArray *)ancilliaryProtocols;

@end
