//
//  LRExpectationActionSyntax.h
//  Mocky
//
//  Created by Luke Redpath on 06/01/2013.
//
//

#import <Foundation/Foundation.h>

@class LRMockyStateMachine;

@protocol LRExpectationActionSyntax <NSObject>

- (void)returns:(id)returnObject;
- (void)returnsValue:(void *)value;
- (void)performsBlock:(void (^)(NSInvocation *))block;
- (void)raisesException:(NSException *)exception;
- (void)doesAllOf:(void (^)(id<LRExpectationActionSyntax>))actionsBlock;
- (void)onConsecutiveCalls:(void (^)(id<LRExpectationActionSyntax>))actionsBlock;
- (void)state:(LRMockyStateMachine *)state becomes:(NSString *)newState;

@end
