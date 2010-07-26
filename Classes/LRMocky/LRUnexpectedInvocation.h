//
//  LRUnexpectedInvocation.h
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRExpectation.h"

@interface LRUnexpectedInvocation : NSObject <LRExpectation> {
  NSInvocation *invocation;
}
@property (nonatomic, retain) NSInvocation *invocation;

+ (id)unexpectedInvocation:(NSInvocation *)invocation;
- (id)initWithInvocation:(NSInvocation *)anInvocation;
@end
