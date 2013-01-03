//
//  LRExpectationCapture.h
//  Mocky
//
//  Created by Luke Redpath on 03/01/2013.
//
//

@protocol LRExpectationCapture <NSObject>

- (void)createExpectationFromInvocation:(NSInvocation *)invocation;

@end

@protocol LRExpectationCaptureSyntaticSugar <NSObject>

- (id)of;

@end
