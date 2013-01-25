//
//  LRExpectationBuilder.h
//  Mocky
//
//  Created by Luke Redpath on 04/01/2013.
//
//

#import "LRExpectationCollector.h"
#import "LRExpectationAction.h"

@protocol LRExpectationBuilder <NSObject>

- (void)setAction:(id<LRExpectationAction>)action;
- (void)buildExpectations:(id<LRExpectationCollector>)expectationCollector;

@end
