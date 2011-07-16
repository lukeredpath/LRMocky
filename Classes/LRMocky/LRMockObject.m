//
//  LRMockObject.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRMockObject.h"
#import "LRMockery.h"
#import "LRClassImposterizer.h"
#import "LRProtocolImposterizer.h"
#import "LRInvocationExpectation.h"
#import "LRUnexpectedInvocation.h"

@interface LRMockery (MockObjectDispatch)
- (void)dispatchInvocation:(NSInvocation *)invocation forMock:(LRMockObject *)mockObject;
@end

@implementation LRMockObject

@synthesize name;

+ (id)mockForClass:(Class)aClass inContext:(LRMockery *)mockery;
{
  LRClassImposterizer *imposterizer = [[[LRClassImposterizer alloc] initWithClass:aClass] autorelease];
  return [[[self alloc] initWithImposterizer:imposterizer context:mockery] autorelease];
}

+ (id)mockForProtocol:(Protocol *)protocol inContext:(LRMockery *)mockery;
{
  LRProtocolImposterizer *imposterizer = [[[LRProtocolImposterizer alloc] initWithProtocol:protocol] autorelease];
  return [[[self alloc] initWithImposterizer:imposterizer context:mockery] autorelease];
}

- (id)initWithImposterizer:(LRImposterizer *)anImposterizer context:(LRMockery *)mockery;
{
  if (self = [super initWithImposterizer:anImposterizer]) {
    context = [mockery retain];
  }
  return self;
}

- (void)dealloc;
{
  [name release];
  [context release];
  [super dealloc];
}

- (NSString *)description
{
  NSMutableString *description = [NSMutableString stringWithString:@"<LRMockObject "];
  if (self.name) {
    [description appendFormat:@"named:\"%@\" ", self.name];
  }
  [description appendFormat:@"%@>", [imposterizer description]];
  return description;
}

- (void)handleImposterizedInvocation:(NSInvocation *)invocation
{
  [context dispatchInvocation:invocation forMock:self];
}

@end

@implementation LRMockery (MockObjectDispatch)

- (void)dispatchInvocation:(NSInvocation *)invocation forMock:(LRMockObject *)mockObject;
{
  for (id<LRExpectation> expectation in expectations) {
    if ([expectation respondsToSelector:@selector(matches:)] && [(LRInvocationExpectation *)expectation matches:invocation]) {
      if ([expectation respondsToSelector:@selector(calledWithInvalidState)] && expectation.calledWithInvalidState == YES) {
        return;
      }
      return [(LRInvocationExpectation *)expectation invoke:invocation];
    }
  }
  LRUnexpectedInvocation *unexpectedInvocation = [LRUnexpectedInvocation unexpectedInvocation:invocation];
  unexpectedInvocation.mockObject = mockObject;
  [expectations addObject:unexpectedInvocation];
}

@end
