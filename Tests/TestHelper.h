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

@interface FakeTestCase : NSObject
{
  NSMutableArray *failures;
}
@property (nonatomic, readonly) NSArray *failures;
- (NSUInteger)numberOfFailures;
@end

@interface SimpleObject : NSObject
{}
- (void)doSomething;
- (id)returnSomething;
- (int)returnSomeValue;
- (id)returnSomethingForValue:(NSString *)value;
- (void)doSomethingWith:(id)object andObject:(id)another;
- (void)doSomethingWithInt:(NSInteger)anInt;
@end

@protocol LRTestCase;

id<HCMatcher> passed();
id<HCMatcher> failedWithNumberOfFailures(int numberOfFailures);