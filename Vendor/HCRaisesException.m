//
//  HCRaisesException.m
//  Mocky
//
//  Created by Luke Redpath on 07/01/2013.
//
//

#import "HCRaisesException.h"
#import <OCHamcrest/HCIsEqual.h>
#import <OCHamcrest/HCHasProperty.h>
#import <OCHamcrest/HCDescription.h>

@implementation HCRaisesException {
  id<HCMatcher> _exceptionMatcher;
  NSException *_exceptionRaised;
}

- (id)initWithExceptionOrMatcher:(id)exceptionOrMatcher
{
  if ((self = [super init])) {
    if ([exceptionOrMatcher conformsToProtocol:@protocol(HCMatcher)]) {
      _exceptionMatcher = exceptionOrMatcher;
    }
    else if ([exceptionOrMatcher isKindOfClass:[NSException class]]) {
      _exceptionMatcher = HC_equalTo(exceptionOrMatcher);
    }
    else {
      @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"HCRaisesException matcher expected a matcher or instance of NSException" userInfo:nil];
    }
  }
  return self;
}

- (BOOL)matches:(id)item {
  // how can we check this at runtime?
  dispatch_block_t block = (dispatch_block_t)item;
  
  @try {
    block();
  }
  @catch (NSException *exception) {
    _exceptionRaised = exception;
    
    return [_exceptionMatcher matches:exception];
  }
  return NO;
}

- (void)describeMismatchOf:(id)item to:(id<HCDescription>)mismatchDescription
{
  if (_exceptionRaised) {
    [mismatchDescription appendText:[NSString stringWithFormat:@"raised <%@: %@>", _exceptionRaised.name, _exceptionRaised.reason]];
  }
  else {
    [mismatchDescription appendText:@"no exception was raised."];
  }
}

- (void)describeTo:(id<HCDescription>)description
{
  [[description appendText:@"block to raise an exception matching "] appendDescriptionOf:_exceptionMatcher];
}

@end

id<HCMatcher> raisesException(id exceptionOrMatcher) {
  return [[HCRaisesException alloc] initWithExceptionOrMatcher:exceptionOrMatcher];
}

id<HCMatcher> raisesExceptionWithType(NSString *name) {
  return raisesException(HC_hasProperty(@"name", HC_equalTo(name)));
}
