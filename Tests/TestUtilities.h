//
//  TestUtilities.h
//  Mocky
//
//  Created by Luke Redpath on 03/01/2013.
//
//

#import <Foundation/Foundation.h>
#import "LRInvokable.h"

NSInvocation *anyValidInvocation(void);

@interface CapturesInvocations : NSObject <LRInvokable>

@property (nonatomic, readonly) NSArray *capturedInvocations;
@property (nonatomic, readonly) NSInvocation *lastInvocation;

@end
