//
//  LRExpectationProxy.h
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LRExpectationProxy : NSProxy {
  Class proxiedClass;
  NSMutableArray *expectations;
}
+ (id)proxyForClass:(Class)aClass;
- (id)initWithClass:(Class)aClass;
- (BOOL)hasExpectationMatchingInvocation:(NSInvocation *)invocation;
@end
