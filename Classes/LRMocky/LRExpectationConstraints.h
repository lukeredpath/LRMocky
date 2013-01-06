//
//  LRExpectationConstraints.h
//  Mocky
//
//  Created by Luke Redpath on 06/01/2013.
//
//

#import "LRExpectationCardinality.h"

@protocol LRExpectationConstraint <NSObject>

- (BOOL)allowsInvocation:(NSInvocation *)invocation;

@end

typedef BOOL (^LRExpectationInvocationBlock)(NSInvocation *invocation);

@interface LRExpectationConstraintUsingBlock : NSObject <LRExpectationConstraint>

+ (id)constraintWithBlock:(LRExpectationInvocationBlock)block;

@end

@interface LRInCorrectStateConstraint : NSObject <LRExpectationConstraint>

+ (id)constraintWithState:(id)state;

@end

@interface LRCardinalityConstraint : NSObject <LRExpectationConstraint>

@property (nonatomic, readonly) NSUInteger invocationCount;

+ (id)constraintWithCardinality:(id<LRExpectationCardinality>)cardinality;
- (void)incrementInvocationCount;

@end

id<LRExpectationConstraint> LRCanBeAnythingConstraint(void);
