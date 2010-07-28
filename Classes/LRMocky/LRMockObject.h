//
//  LRMockObject.h
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRImposter.h"

@class LRMockery;

@interface LRMockObject : LRClassImposter {
  Class mockedClass;
  LRMockery *context;
  NSString *name;
}
@property (nonatomic, readonly) Class mockedClass;
@property (nonatomic, copy) NSString *name;

+ (id)mockForClass:(Class)aClass inContext:(LRMockery *)mockery;
- (id)initWithClass:(Class)aClass context:(LRMockery *)mockery;
@end
