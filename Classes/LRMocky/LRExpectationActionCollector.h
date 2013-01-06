//
//  LRExpectationActionCollector.h
//  Mocky
//
//  Created by Luke Redpath on 06/01/2013.
//
//

#import "LRExpectationAction.h"

@protocol LRExpectationActionCollector <NSObject>

- (void)addAction:(id<LRExpectationAction>)action;

@end
