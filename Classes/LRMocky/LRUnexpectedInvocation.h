//
//  LRUnexpectedInvocation.h
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRExpectation.h"

@class OLD_LRMockObject;

@interface LRUnexpectedInvocation : NSObject <LRExpectation> {
  NSInvocation *invocation;
  OLD_LRMockObject *mockObject;
}
@property (nonatomic, retain) NSInvocation *invocation;
@property (nonatomic, retain) OLD_LRMockObject *mockObject;

+ (id)unexpectedInvocation:(NSInvocation *)invocation;
- (id)initWithInvocation:(NSInvocation *)anInvocation;
@end
