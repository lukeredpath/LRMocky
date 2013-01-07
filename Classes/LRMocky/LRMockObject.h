//
//  LRMockyObject.h
//  Mocky
//
//  Created by Luke Redpath on 03/01/2013.
//
//

#import "LRInvocationDispatcher.h"
#import "LRInvokable.h"
#import "LRExpectationCapture.h"

@protocol LRImposterizable <NSObject>

- (id)imposterizeTo:(id<LRInvokable>)invokable ancilliaryProtocols:(NSArray *)ancilliaryProtocols;

@end

@protocol LRCaptureControl <NSObject>

- (id)captureExpectationTo:(id<LRExpectationCapture>)capture;

@end

@interface LRMockObject : NSObject <LRInvokable, LRCaptureControl, LRImposterizable>

@property (nonatomic, readonly) NSString *name;

- (id)initWithInvocationDispatcher:(id<LRInvocationDispatcher>)dispatcher
                        mockedType:(id)mockedType
                              name:(NSString *)name;

- (id)imposterize;

@end
