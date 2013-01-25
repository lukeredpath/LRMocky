//
//  LRNotificationExpectation.m
//  Mocky
//
//  Created by Luke Redpath on 31/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRNotificationExpectation.h"
#import "LRHamcrestSupport.h"

#import <OCHamcrest/HCDescription.h>

@interface LRNotificationExpectation ()
@property (nonatomic, strong) id senderMatcher;
@end

@implementation LRNotificationExpectation

@synthesize action = _action;
@synthesize statePredicate = _statePredicate;

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
  if (self.statePredicate && ![self.statePredicate isActive]) return;

  if (self.senderMatcher) {
    _isSatisfied = [self.senderMatcher matches:note.object];
    
    [self.action invoke:nil];
  }
  else {
    _isSatisfied = YES;
  }
}

- (void)dealloc
{
  [self.notificationCenter removeObserver:self];
}

- (BOOL)matches:(id)object
{
  return NO;
}

- (void)invoke:(NSInvocation *)invocation // will never be called
{} 

- (void)describeTo:(id<HCDescription>)description
{
  [description appendText:[NSString stringWithFormat:@"Expected to receive notification named %@", self.name]];
  if (self.sender) {
    [description appendText:[NSString stringWithFormat:@" from %@", self.sender]];
  }
  [description appendText:@", but notification was not posted."];
}

@end
