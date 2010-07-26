//
//  LRExpectationBuilder.h
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRImposter.h"

@class LRMockObject;
@class LRMockery;

@interface LRExpectationBuilder : LRClassImposter {
  LRMockery *mockery;
  Class mockedClass;
}
+ (id)builderInContext:(LRMockery *)context;
- (id)initWithMockery:(LRMockery *)aMockery;
- (id)oneOf:(id)mockObject;
@end
