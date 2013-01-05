//
//  LRAllParametersMatcher.h
//  Mocky
//
//  Created by Luke Redpath on 05/01/2013.
//
//

#import <OCHamcrest/HCBaseMatcher.h>
#import "LRDescribable.h"

@interface LRAllParametersMatcher : HCBaseMatcher <LRDescribable>

- (id)initWithParameters:(NSArray *)parameters;

@end
