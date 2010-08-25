//
//  LRImposterizer.h
//  Mocky
//
//  Created by Luke Redpath on 24/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ImposterizerDelegate)
- (void)handleImposterizedInvocation:(NSInvocation *)invocation;
@end

@interface LRImposterizer : NSObject {
  id delegate;
}
@property (nonatomic, assign) id delegate;

- (LRImposterizer *)matchingImposterizer;
@end
