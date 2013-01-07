//
//  NSObject+Identity.m
//  Mocky
//
//  Created by Luke Redpath on 07/01/2013.
//
//

#import "NSObject+Identity.h"
#import <objc/runtime.h>

@implementation NSObject (Identity)

- (BOOL)LR_isClass
{
  return class_isMetaClass(object_getClass(self));
}

- (BOOL)LR_isProtocol
{
  return [self class] == NSClassFromString(@"Protocol");
}

@end
