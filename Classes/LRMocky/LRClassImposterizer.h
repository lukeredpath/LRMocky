//
//  LRClassImposterizer.h
//  Mocky
//
//  Created by Luke Redpath on 24/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLD_LRImposterizer.h"

@interface LRClassImposterizer : OLD_LRImposterizer {
  Class klassToImposterize;
}
- (id)initWithClass:(Class)klass;
@end
