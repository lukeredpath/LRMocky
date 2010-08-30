//
//  LRNotificationExpectation.m
//  Mocky
//
//  Created by Luke Redpath on 31/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRNotificationExpectation.h"
#import "LRExpectationMessage.h"

@implementation LRNotificationExpectation

+ (id)expectationWithNotificationName:(NSString *)name;
{
  return [[[self alloc] initWithName:name sender:nil] autorelease];
}

+ (id)expectationWithNotificationName:(NSString *)name sender:(id)sender;
{
  return [[[self alloc] initWithName:name sender:sender] autorelease];
}

- (id)initWithName:(NSString *)notificationName sender:(id)object;
{
  if (self = [super init]) {
    isSatisfied = NO;
    name = [notificationName copy];
    sender = [object retain];
    
    [[NSNotificationCenter defaultCenter] 
        addObserver:self 
           selector:@selector(receiveNotification:) 
               name:name 
             object:sender];
  }
  return self;
}

- (void)receiveNotification:(NSNotification *)note
{
  isSatisfied = YES;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [name release];
  [sender release];
  [super dealloc];
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
