//
//  LRExpectationActions.h
//  Mocky
//
//  Created by Luke Redpath on 06/01/2013.
//
//

#import "LRExpectationActionSyntax.h"
#import "LRExpectationActionCollector.h"

@interface LRExpectationActions : NSObject <LRExpectationActionSyntax>

- (id)initWithActionCollector:(id<LRExpectationActionCollector>)collector;

@end
