//
//  LRExpectations.h
//  Mocky
//
//  Created by Luke Redpath on 04/01/2013.
//
//

#import "LRExpectationBuilder.h"
#import "LRExpectationCapture.h"

@interface LRExpectations : NSObject <LRExpectationBuilder>

+ (id)captureExpectationsWithBlock:(dispatch_block_t)block;

#pragma mark - Mock object expectations

- (id)expectThat:(id)mock;
- (id)allowing:(id)mock;
- (id)ignoring:(id)mock;

#pragma mark - Expectation cardinality

- (id)receives;
- (id)receivesExactly:(NSUInteger)count;
- (id)receivesAtLeast:(NSUInteger)min;
- (id)receivesAtMost:(NSUInteger)max;
- (id)receivesBetween:(NSUInteger)min and:(NSUInteger)max;

#pragma mark - Expectation actions

- (void)returns:(id)returnObject;
- (void)performBlock:(void (^)(NSInvocation *))block;
- (void)onConsecutiveCalls:(void (^)(id))sequenceBlock;

#pragma mark - NSNotification expectations

- (id)expectNotification:(NSString *)notificationName;
- (id)fromSender:(id)sender;
- (id)viaNotificationCenter:(NSNotificationCenter *)notificationCenter;

@end

@interface LRNotificationExpectationBuilder : NSObject <LRExpectationBuilder>

@property (nonatomic, strong) NSNotificationCenter *notificationCenter;
@property (nonatomic, copy) NSString *notificationName;
@property (nonatomic, strong) id sender;

@end

#pragma mark - Global expectation builder proxy functions

LRExpectations *expectThat(id object);
id allowing(id object);
id ignoring(id object);
LRExpectations *andThen(void);
LRExpectations *expectNotification(NSString *name);

/* Makes the interface a little bit more readable 
 */
#ifdef MOCKY_SHORTHAND
  #define then andThen()
#endif
