//
//  HCRaisesException.h
//  Mocky
//
//  Created by Luke Redpath on 07/01/2013.
//
//

#import <OCHamcrest/HCBaseMatcher.h>

@interface HCRaisesException : HCBaseMatcher

- (id)initWithExceptionOrMatcher:(id)exceptionOrMatcher;

@end

id<HCMatcher> raisesException(id exceptionOrMatcher);
id<HCMatcher> raisesExceptionWithType(NSString *name);
