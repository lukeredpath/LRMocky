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


@implementation LRNotificationExpectation

+ (id)expectationWithNotificationName:(NSString *)name;
{
  return [[self alloc] initWithName:name sender:nil];
}

+ (id)expectationWithNotificationName:(NSString *)name sender:(id)sender;
{
  return [[self alloc] initWithName:name sender:sender];
}

- (id)initWithName:(NSString *)notificationName sender:(id)object;
{
  if (self = [super init]) {
    isSatisfied = NO;
    name = [notificationName copy];
    sender = object;
    
    id notificationObject = sender;
    
    if ([sender conformsToProtocol:NSProtocolFromString(@"HCMatcher")]) {
      notificationObject = nil;
    }
    
    [[NSNotificationCenter defaultCenter] 
        addObserver:self 
           selector:@selector(receiveNotification:) 
               name:name 
             object:notificationObject];
  }
  return self;
}

- (void)receiveNotification:(NSNotification *)note
{
  if ([sender conformsToProtocol:NSProtocolFromString(@"HCMatcher")]) {
    isSatisfied = [sender matches:note.object];
  }
  else {
    isSatisfied = YES;
  }
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addAction:(id <LRExpectationAction>)action
{} // not supported yet

- (BOOL)isSatisfied
{
  return isSatisfied;
}

- (void)describeTo:(LRExpectationMessage *)message
{
  [message append:[NSString stringWithFormat:@"Expected to receive notification named %@", name]];
  if (sender) {
    [message append:[NSString stringWithFormat:@" from %@", sender]];
  }
  [message append:@", but notification was not posted."];
}

@end
