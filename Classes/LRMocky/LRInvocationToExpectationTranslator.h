//
//  LRInvocationToExpectationTranslator.h
//  Mocky
//
//  Created by Luke Redpath on 03/01/2013.
//
//

#import "LRInvokable.h"
#import "LRExpectationCapture.h"

@interface LRInvocationToExpectationTranslator : NSObject <LRInvokable>

- (id)initWithExpectationCapture:(id<LRExpectationCapture>)capture;

@end

