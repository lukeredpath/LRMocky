//
//  LRCompositeAction.h
//  Mocky
//
//  Created by Luke Redpath on 06/01/2013.
//
//

#import "LRExpectationAction.h"
#import "LRExpectationActionCollector.h"

@interface LRCompositeAction : NSObject <LRExpectationAction, LRExpectationActionCollector>

@end
