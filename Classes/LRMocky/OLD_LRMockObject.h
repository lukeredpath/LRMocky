//
//  LRMockObject.h
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLD_LRImposter.h"

@class LRMockery;
@class OLD_LRImposterizer;

@interface OLD_LRMockObject : OLD_LRImposter {
  LRMockery *context;
  NSString *name;
}
@property (nonatomic, copy) NSString *name;

+ (id)mockForClass:(Class)aClass inContext:(LRMockery *)mockery;
+ (id)mockForProtocol:(Protocol *)protocol inContext:(LRMockery *)mockery;
+ (id)partialMockForObject:(id)object inContext:(LRMockery *)context;
- (id)initWithImposterizer:(OLD_LRImposterizer *)anImposterizer context:(LRMockery *)mockery;
- (void)undoSideEffects;
@end
