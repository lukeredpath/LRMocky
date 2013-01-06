//
//  LRExpectations.h
//  Mocky
//
//  Created by Luke Redpath on 04/01/2013.
//
//

#import "LRExpectationBuilder.h"
#import "LRExpectationCapture.h"
#import "LRExpectationActionSyntax.h"
#import "LRExpectationActionCollector.h"

@interface LRExpectations : NSObject <LRExpectationBuilder, LRExpectationActionCollector>

@property (nonatomic, readonly) id<LRExpectationActionSyntax> actions;

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
LRExpectations *expectNotification(NSString *name);
id allowing(id object);
id ignoring(id object);
id<LRExpectationActionSyntax> andThen(void);
id thenStateOf(id state);
id whenStateOf(id state);

/* Makes the interface a little bit more readable 
 */
#ifdef MOCKY_SHORTHAND
  #define then andThen()
#endif
