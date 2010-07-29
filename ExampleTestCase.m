//
//  ExampleTestCase.m
//  Mocky
//
//  Created by Luke Redpath on 28/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#define LRMOCKY_SHORTHAND
#define LRMOCKY_SUGAR
#define HC_SHORTHAND

#import <SenTestingKit/SenTestingKit.h>
#import "OCHamcrest.h"
#import "LRMocky.h"

@interface ExampleTestCase : SenTestCase
{}
@end

@implementation ExampleTestCase

- (void)testSuccessfulMocking
{
  LRMockery *context = [LRMockery mockeryForTestCase:self];

  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [[oneOf(myMockString) receives] uppercaseString];
  }];
  
  [myMockString uppercaseString];
  [context assertSatisfied];
}

- (void)testFailedMocking 
{
  LRMockery *context = [LRMockery mockeryForTestCase:self];
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [[oneOf(myMockString) receives] uppercaseString];
  }];
  
  [myMockString lowercaseString];
  [context assertSatisfied];
}


- (void)testSuccessfulMockingWithMultipleCallsExpected
{
  LRMockery *context = [LRMockery mockeryForTestCase:self];
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [[[atLeast(2) of:myMockString] receives] uppercaseString];
  }];
  
  [myMockString uppercaseString];
  [myMockString uppercaseString];
  [myMockString uppercaseString];
  [context assertSatisfied];
}

- (void)testFailedMockingWithMultipleCallsExpected
{
  LRMockery *context = [LRMockery mockeryForTestCase:self];
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [[[between(2, 4) of:myMockString] receives] uppercaseString];
  }];
  
  [myMockString uppercaseString];
  [context assertSatisfied];
}

- (void)testSuccessfulMockingWithHamcrest 
{
  LRMockery *context = [LRMockery mockeryForTestCase:self];
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [[oneOf(myMockString) receives] stringByAppendingString:with(startsWith(@"super"))];
  }];
  
  [myMockString stringByAppendingString:@"super"];
  [context assertSatisfied];
}

- (void)testFailedMockingWithHamcrest 
{
  LRMockery *context = [LRMockery mockeryForTestCase:self];
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [[oneOf(myMockString) receives] stringByAppendingString:with(startsWith(@"super"))];
  }];
  
  [myMockString stringByAppendingString:@"not super"];
  [context assertSatisfied];
}

- (void)testSuccessfulMockWithReturnValue
{
  LRMockery *context = [LRMockery mockeryForTestCase:self];
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [[oneOf(myMockString) receives] uppercaseString]; andThen(returnsObject(@"FOOBAR"));
  }];
  
  NSString *returnedValue = [myMockString uppercaseString];
  [context assertSatisfied];

  assertThat(returnedValue, equalTo(@"FOOBAR"));
}

- (void)testSuccessfulMockWithPerformedBlock
{
  LRMockery *context = [LRMockery mockeryForTestCase:self];
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  __block id outsideTheBlock = nil;
  
  [context checking:^(that){
    [[oneOf(myMockString) receives] uppercaseString]; andThen(performsBlock(^(NSInvocation *invocation) {
      outsideTheBlock = @"FOOBAR";
    }));
  }];
  
  [myMockString uppercaseString];
  [context assertSatisfied];
  
  assertThat(outsideTheBlock, equalTo(@"FOOBAR"));
}

@end
