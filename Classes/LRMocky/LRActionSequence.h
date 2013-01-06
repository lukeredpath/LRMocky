//
//  LRActionSequence.h
//  Mocky
//
//  Created by Luke Redpath on 06/01/2013.
//
//

#import "LRExpectationActionSyntax.h"

@interface LRActionSequence : NSObject <LRExpectationActionSyntax>

@property (nonatomic, readonly) NSArray *actions;

+ (id)sequenceWithBlock:(void (^)(LRActionSequence *))sequenceBlock;

@end
