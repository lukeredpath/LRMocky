//
//  LRSynchroniser.h
//  Mocky
//
//  Created by Luke Redpath on 10/01/2013.
//
//

#import <Foundation/Foundation.h>
#import "LRStatePredicate.h"

@interface LRSynchroniser : NSObject

+ (id)synchroniser;
+ (id)synchroniserWithTimeout:(NSTimeInterval)timeout;
- (void)waitUntil:(id<LRStatePredicate>)statePredicate;

@end
