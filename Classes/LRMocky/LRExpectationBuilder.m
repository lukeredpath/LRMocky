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
#import "LRPerformBlockAction.h"
#import "NSInvocation+OCMAdditions.h"

@interface LRExpectationBuilder ()
@property (nonatomic, readonly) LRInvocationExpectation *currentExpectation;
@end

@implementation LRExpectationBuilder {
  id<LRExpectationCollector> _expectationCollector;
  id _capturingImposter;
  NSMutableArray *_expectations;
}

#pragma mark - Global expectation builder access

static LRExpectationBuilder *__currentExpectationBuilder = nil;

+ (void)buildExpectationsWithBlock:(dispatch_block_t)expectationBlock collectUsing:(id<LRExpectationCollector>)collector
{
  __currentExpectationBuilder = [[self alloc] initWithExpectationCollector:collector];
  
    expectationBlock();
  
  [__currentExpectationBuilder collectExpectations];
}

+ (LRExpectationBuilder *)currentExpectationBuilder
{
  return __currentExpectationBuilder;
}

#pragma mark -

- (id)initWithExpectationCollector:(id<LRExpectationCollector>)expectationCollector
{
  if (self = [super init]) {
    _expectationCollector = expectationCollector;
    _expectations = [[NSMutableArray alloc] init];
  }
  return self;
}

- (id<LRExpectation>)currentExpectation
{
  return [_expectations lastObject];
}

- (void)collectExpectations
{
  for (id<LRExpectation> expectation in _expectations) {
    [_expectationCollector addExpectation:expectation];
  }
  [_expectations removeAllObjects];
}

#pragma mark - Fluent Interface

- (id)setExpectationTarget:(id)object
{
  if (![object conformsToProtocol:@protocol(LRCaptureControl)]) {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Can only set expectations on mock objects!"
                                 userInfo:nil];
  }
  [_expectations addObject:[LRInvocationExpectation expectationWithObject:object]];
  
  _capturingImposter = [(id<LRCaptureControl>)object captureExpectationTo:(id<LRExpectationCapture>)self];
  
  return self;
}

- (id)receives;
{
  return [self receives:LRM_exactly(1)];
}

- (id)receives:(id<LRExpectationCardinality>)cardinality
{
  self.currentExpectation.cardinality = cardinality;
  
  return _capturingImposter;
}

- (id)neverReceives
{
  [self receives:LRM_exactly(0)];
  
  return _capturingImposter;
}

- (id)of
{
  return _capturingImposter;
}

- (void)requiresState:(LRMockyState *)state;
{
  self.currentExpectation.requiredState = state;
}

- (void)shouldTransitionToState:(LRMockyState *)state;
{
  [self.currentExpectation addAction:[LRMockyStateTransitionAction transitionToState:state]];
}

- (id)then:(id)action
{
  if ([action conformsToProtocol:@protocol(LRExpectationAction)]) {
    [self.currentExpectation addAction:action];
  }
  else {
    // we will *assume* it's a block - not very safe, we'll have
    // to rely on clients of this method to do the right thing.
    
    LRInvocationActionBlock actionBlock = (LRInvocationActionBlock)action;
    action = [[LRPerformBlockAction alloc] initWithBlock:actionBlock];
    [self.currentExpectation addAction:action];
  }
  return self;
}

#pragma mark - LRExpectationCapture

- (void)createExpectationFromInvocation:(NSInvocation *)invocation
{
  self.currentExpectation.invocation = invocation;
}


@end
