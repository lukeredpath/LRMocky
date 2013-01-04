//
//  LRExpectationCollector.h
//  Mocky
//
//  Created by Luke Redpath on 04/01/2013.
//
//

#import "LRExpectation.h"

@protocol LRExpectationCollector <NSObject>

- (void)addExpectation:(id<LRExpectation>)expectation;

@end
