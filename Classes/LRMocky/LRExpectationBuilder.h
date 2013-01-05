//
//  LRExpectationBuilder.h
//  Mocky
//
//  Created by Luke Redpath on 04/01/2013.
//
//

#import "LRExpectationCollector.h"

@protocol LRExpectationBuilder <NSObject>

- (void)buildExpectations:(id<LRExpectationCollector>)expectationCollector;

@end
