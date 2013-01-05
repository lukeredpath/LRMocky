//
//  LRNotificationExpectation.m
//  Mocky
//
//  Created by Luke Redpath on 31/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRNotificationExpectation.h"
#import "LRExpectationMessage.h"
#import "LRHamcrestSupport.h"

@interface LRNotificationExpectation ()
@property (nonatomic, strong) id senderMatcher;
@end

@implementation LRNotificationExpectation

+ (id)expectationWithNotificationName:(NSString *)name;
{
  return [[self alloc] initWithName:name sender:nil];
}

+ (id)expectationWithNotificationName:(NSString *)name sender:(id)sender;
{
  return [[self alloc] initWithName:name sender:sender];
}

- (id)init
{
  self = [super init];
  if (self) {
    self.notificationCenter = [NSNotificationCenter defaultCenter];
  }
  return self;
}

- (id)initWithName:(NSString *)notificationName sender:(id)object;
{
  if (self = [super init]) {
    self.name = notificationName;
    self.sender = object;
  }
  return self;
}

- (void)setSender:(id)sender
{
  if ([sender conformsToProtocol:NSProtocolFromString(@"HCMatcher")]) {
    _sender = nil;
    self.senderMatcher = sender;
  }
  else {
    _sender = sender;
  }
}

- (void)waitForNotification
{
  [self.notificationCenter addObserver:self selector:@selector(receiveNotification:) name:self.name object:self.sender];
}

- (void)receiveNotification:(NSNotification *)note
{
  if (self.senderMatcher) {
    _isSatisfied = [self.senderMatcher matches:note.object];
  }
  else {
    _isSatisfied = YES;
  }
}

- (void)dealloc
{
  [self.notificationCenter removeObserver:self];
}

- (void)addAction:(id <LRExpectationAction>)action
{} // not supported yet

- (void)invoke:(NSInvocation *)invocation
{} // not applicable

- (void)describeTo:(LRExpectationMessage *)message
{
  [message append:[NSString stringWithFormat:@"Expected to receive notification named %@", self.name]];
  if (self.sender) {
    [message append:[NSString stringWithFormat:@" from %@", self.sender]];
  }
  [message append:@", but notification was not posted."];
}

@end
