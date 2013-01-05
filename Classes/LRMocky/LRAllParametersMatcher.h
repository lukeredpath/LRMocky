//
//  LRAllParametersMatcher.h
//  Mocky
//
//  Created by Luke Redpath on 05/01/2013.
//
//

#import <OCHamcrest/HCBaseMatcher.h>
#import "HCSelfDescribing.h"

@interface LRAllParametersMatcher : HCBaseMatcher

- (id)initWithParameters:(NSArray *)parameters;

@end
