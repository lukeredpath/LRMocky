//
//  NSInvocation+Conveniences.h
//  Mocky
//
//  Created by Luke Redpath on 05/01/2013.
//
//

#import <Foundation/Foundation.h>

@interface NSInvocation (Conveniences)

@property (nonatomic, readonly) NSArray *argumentsArray;
@property (nonatomic, readonly) NSUInteger numberOfActualArguments;

- (void)putObject:(id)object asArgumentAtIndex:(NSUInteger)index;

- (void)setReturnValueFromObject:(id)object;

@end
