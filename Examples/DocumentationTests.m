//
//  DocumentationTests.m
//  Mocky
//
//  Created by Luke Redpath on 08/01/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "TestHelper.h"
#import <Mocky/Mocky.h>

#pragma mark - Interfaces

@protocol Subscriber

- (void)receive:(NSString *)message;

@end

@interface Publisher : NSObject

- (void)addSubscriber:(id<Subscriber>)subscriber;
- (void)publish:(NSString *)message;

@end

#pragma mark - Tests

DEFINE_TEST_CASE(PublisherTest) {
  LRMockery *context;
}

- (void)setUp
{
  context = [LRMockery mockeryForTestCase:self];
}

- (void)testSubscriberReceivesMessage
{
  id<Subscriber> subscriber = [context mock:@protocol(Subscriber)];
  
  Publisher *publisher = [[Publisher alloc] init];
  [publisher addSubscriber:subscriber];
  
  NSString *message = @"some message";
  
  [context check:^{
    [[expectThat(subscriber) receives] receive:message];
  }];
  
  [publisher publish:message];
  
  assertContextSatisfied(context);
}

- (void)testMultipleSubscribersReceiveMessages
{
  id<Subscriber> subscriberOne = [context mock:@protocol(Subscriber) named:@"subscriber one"];
  id<Subscriber> subscriberTwo = [context mock:@protocol(Subscriber) named:@"subscriber two"];
  
  Publisher *publisher = [[Publisher alloc] init];
  [publisher addSubscriber:subscriberOne];
  [publisher addSubscriber:subscriberTwo];
  
  NSString *message = @"some message";
  
  [context check:^{
    [[expectThat(subscriberOne) receives] receive:message];
    [[expectThat(subscriberTwo) receives] receive:message];
  }];
  
  [publisher publish:message];
  
  assertContextSatisfied(context);
}

END_TEST_CASE

#pragma mark - Implementation

@implementation Publisher {
  NSMutableSet *_subscribers;
}

- (id)init
{
  self = [super init];
  if (self) {
    _subscribers = [[NSMutableSet alloc] init];
  }
  return self;
}

- (void)addSubscriber:(id<Subscriber>)subscriber
{
  [_subscribers addObject:subscriber];
}

- (void)publish:(NSString *)message
{
  [_subscribers makeObjectsPerformSelector:@selector(receive:) withObject:message];
}

@end
