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

- (void)handleImposterizedInvocation:(NSInvocation *)invocation
{
  [context dispatchInvocation:invocation forMock:self];
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

@end
