//
//  LRExpectationBuilder.h
//  Mocky
//
//  Created by Luke Redpath on 04/01/2013.
//
//

#import "LRExpectationCollector.h"
#import "LRExpectationAction.h"
#import "LRStatePredicate.h"

@protocol LRExpectationBuilder <NSObject>

- (void)buildExpectations:(id<LRExpectationCollector>)expectationCollector;

@optional

- (void)setAction:(id<LRExpectationAction>)action;
- (void)setStatePredicate:(id<LRStatePredicate>)statePredicate;

@end
