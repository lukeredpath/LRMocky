//
//  TestHelper.h
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#define HC_SHORTHAND
#import "OCHamcrest.h"
#import "LRTestCase.h"

@interface NSInvocation (LRAdditions)
+ (NSInvocation *)invocationForSelector:(SEL)selector onClass:(Class)aClass;
@end

@interface MockTestCase : NSObject <LRTestCase>
{
  NSMutableArray *failures;
}
- (NSUInteger)numberOfFailures;
@end

@interface SimpleObject : NSObject
{}
- (void)doSomething;
- (id)returnSomething;
@end

@protocol LRTestCase;

id<HCMatcher> passed();
id<HCMatcher> failedWithNumberOfFailures(int numberOfFailures);