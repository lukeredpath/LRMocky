//
//  LRExpectationBuilder.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRExpectationBuilder.h"
#import "LRMockObject.h"
#import "LRMockery.h"
#import "LRInvocationExpectation.h"
#import "LRExpectationCardinality.h"
#import "LRMockyStates.h"
#import "LRObjectImposterizer.h"
#import "NSInvocation+OCMAdditions.h"

@interface LRExpectationBuilder ()
@property (nonatomic, retain) LRInvocationExpectation *currentExpecation;
@property (nonatomic, readonly) LRImposterizer *imposterizer;

- (id)initWithMockery:(LRMockery *)aMockery;
- (void)actAsImposterForMockObject:(LRMockObject *)mock;

@end

@implementation LRExpectationBuilder {
  LRMockery *_mockery;
  LRImposterizer *_imposterizer;
}
@synthesize currentExpecation;

#pragma mark - Global expectation builder access

static LRExpectationBuilder *__currentExpectationBuilder = nil;

+ (void)buildExpectationsWithBlock:(dispatch_block_t)expectationBlock inContext:(LRMockery *)context
{
  __currentExpectationBuilder = [[self alloc] initWithMockery:context];
  expectationBlock();
}

+ (LRExpectationBuilder *)currentExpectationBuilder
{
  return __currentExpectationBuilder;
}

//+ (id)expectThat:(id)object
//{
//  return [__globalExpectationBuilder oneOf:object];
//}
//
//+ (id)allow:(id)object
//{
//  return [__globalExpectationBuilder allowing:object];
//}
//
//+ (void)setCardinalityForCurrentExpectation:(id<LRExpectationCardinality>)cardinality
//{
//  [__globalExpectationBuilder setCardinalityForCurrentExpectation:cardinality];
//}

#pragma mark -

- (id)initWithMockery:(LRMockery *)aMockery;
{
  if (self = [super init]) {
    _mockery = [aMockery retain];
  }
  return self;
}

- (void)dealloc;
{
  [_imposterizer release];
  [_mockery release];
  [super dealloc];
}

- (id<LRExpectation>)expectation
{
  return self.currentExpecation;
}

- (LRImposterizer *)imposterizer
{
  return self.currentExpecation.mockObject.imposterizer;
}

#pragma mark - Fluent Interface

- (id)setExpectationTarget:(id)object
{
  self.currentExpecation = [self expectationForObject:object];
  return self;
}

- (id)receives;
{
  return self;
}

- (id)receives:(id<LRExpectationCardinality>)cardinality
{
  self.currentExpecation.cardinality = cardinality;
  return self;
}

- (id)neverReceives
{
  [self receives:LRM_exactly(0)];
  return self;
}

- (id)of
{
  return self;
}

- (void)requiresState:(LRMockyState *)state;
{
  self.currentExpecation.requiredState = state;
}

- (void)shouldTransitionToState:(LRMockyState *)state;
{
  [self.currentExpecation addAction:[LRMockyStateTransitionAction transitionToState:state]];
}

- (id)will:(id<LRExpectationAction>)action;
{
  [self.currentExpecation addAction:action];
  return self;
}

#pragma mark - Imposterizer methods

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
  return [self.imposterizer methodSignatureForSelector:sel];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
  return [self.imposterizer respondsToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{  
  self.currentExpecation.invocation = anInvocation;

  if ([self.imposterizer isKindOfClass:[LRObjectImposterizer class]]) {
    [(LRObjectImposterizer *)self.imposterizer setupInvocationHandlerForImposterizedObjectForInvocation:anInvocation];
  }
  [_mockery addExpectation:self.currentExpecation];
}

#pragma mark - Private

- (LRInvocationExpectation *)expectationForObject:(id)object
{
  if (![object isKindOfClass:[LRMockObject class]]) {
    object = [_mockery partialMockForObject:object];
  }
  return [LRInvocationExpectation expectationWithObject:object];
}

@end
