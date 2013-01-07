//
//  LRMockyObject.h
//  Mocky
//
//  Created by Luke Redpath on 03/01/2013.
//
//

#import "LRInvocationDispatcher.h"
#import "LRInvokable.h"
#import "LRImposterizable.h"
#import "LRExpectationCapture.h"

@interface LRMockObject : NSObject <LRInvokable, LRImposterizable>

- (id)initWithInvocationDispatcher:(id<LRInvocationDispatcher>)dispatcher
                        mockedType:(id)mockedType
                              name:(NSString *)name;

- (id)imposterize;

@end
