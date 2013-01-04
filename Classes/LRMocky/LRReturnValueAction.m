//
//  LRReturnValueAction.m
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRReturnValueAction.h"


@implementation LRReturnValueAction

- (id)initWithObject:(id)object;
{
  return [self initWithValue:&object];
}

- (id)initWithValue:(void *)value;
{
  if (self = [super init]) {
    // use NSData to take a copy of the value to ensure it doesn't change
    returnValue = [NSData dataWithBytes:value length:sizeof(value)];
  }
  return self;
}


- (void)invoke:(NSInvocation *)invocation;
{
  [invocation setReturnValue:(void *)[returnValue bytes]];
}

@end

LRReturnValueAction *LRA_returnObject(id object) {
  return [[LRReturnValueAction alloc] initWithObject:object];
}

LRReturnValueAction *LRA_returnValue(void *value) {
  return [[LRReturnValueAction alloc] initWithValue:value];
}

LRReturnValueAction *LRA_returnInt(int anInt) {
  return [[LRReturnValueAction alloc] initWithValue:&anInt];
}

LRReturnValueAction *LRA_returnInteger(NSInteger anInteger) {
  return [[LRReturnValueAction alloc] initWithValue:&anInteger];
}

LRReturnValueAction *LRA_returnFloat(float aFloat) {
  return [[LRReturnValueAction alloc] initWithValue:&aFloat];
}

LRReturnValueAction *LRA_returnLong(long aLong) {
  return [[LRReturnValueAction alloc] initWithValue:&aLong];
}

LRReturnValueAction *LRA_returnBool(BOOL aBool) {
  return [[LRReturnValueAction alloc] initWithValue:&aBool];
}
