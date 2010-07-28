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
  
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(myMockString) uppercaseString];
  }];
  
  [myMockString uppercaseString];
  [context assertSatisfied];
}

- (void)testFailedMocking // this will fail the test case
{
  LRMockery *context = [LRMockery mockeryForTestCase:self];
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(myMockString) uppercaseString];
  }];
  
  [myMockString lowercaseString];
  [context assertSatisfied];
}

- (void)testSuccessfulMockingWithHamcrest 
{
  LRMockery *context = [LRMockery mockeryForTestCase:self];
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(myMockString) stringByAppendingString:(id)with(startsWith(@"super"))];
  }];
  
  [myMockString stringByAppendingString:@"super"];
  [context assertSatisfied];
}

- (void)testFailedMockingWithHamcrest 
{
  LRMockery *context = [LRMockery mockeryForTestCase:self];
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(myMockString) stringByAppendingString:(id)with(startsWith(@"super"))];
  }];
  
  [myMockString stringByAppendingString:@"not super"];
  [context assertSatisfied];
}

@end
