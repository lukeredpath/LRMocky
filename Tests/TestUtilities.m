//
//  TestUtilities.m
//  Mocky
//
//  Created by Luke Redpath on 03/01/2013.
//
//

#import "TestUtilities.h"

NSInvocation *anyValidInvocation(void) {
  NSMethodSignature *validMethodSignature = [NSObject instanceMethodSignatureForSelector:@selector(init)];
  return [NSInvocation invocationWithMethodSignature:validMethodSignature];
}
