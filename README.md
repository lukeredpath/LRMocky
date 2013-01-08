# Mocky, an Objective-C mock objects framework

Mocky is an opinionated, [jMock](http:://jmock.org) inspired mock objects framework for OSX and iOS development. 

It supports class and protocol-based mocking; a simple, expressive API designed for readability; Hamcrest matcher support using [OCHamcrest](http://github.com/hamcrest/OCHamcrest) and ships with support for OCUnit, or any testing framework built on top of it.

Note: This document is currently a work in progress.

## Getting Started

The recommended way of adding Mocky to your project is using [CocoaPods](http://cocoapods.org). Mocky is available as a static library for iOS and a framework for OSX. You can also clone the project repository and add it to Xcode to your workspace or project and build it as a dependency.

### Installation

If you are using CocoaPods, all you need to do is add the following line to your Podfile:

```ruby
pod 'Mocky'
```

Using the framework on OSX is as simple as dragging it into your project. If you are using the static library in an iOS project, you'll also need to put the headers somewhere in your source tree, or reference them on disk by setting the header search path for your test bundle.

## Quick Introduction

[Borrowing from jMock once again](http://jmock.org/getting-started.html), we'll write a test for a simple publish/subscriber system. A publisher can publish messages (represented by strings) to one or more subscribers.

For all of the following examples, the test case `@interface` has been omitted.

### A failing test

Before we can create mocks or set up any expectations, we need a context in which our mocks can exist. In Mocky, this context is defined by an instance of the 'LRMockery' class:

```objc
@implementation PublisherTest {
  LRMockery *context;
}

- (void)setUp
{
  context = [LRMockery mockeryForTestCase:self];
}

@end
```

Now we'll write our first test. We want to assert that given a single subscriber, when we publish a message, the subscriber receives it. At this point, we've defined no classes or protocols other than our test case - we'll write the test first, then write the minimum we need to get the test to compile, before making it pass.

```objc
- (void)testSubscriberReceivesMessage
{
  id<Subscriber> subscriber = [context mock:@protocol(Subscriber)];
    
  Publisher *publisher = [[Publisher alloc] init];
  [publisher addSubscriber:subscriber];
  
  NSString *message = @"some message";
    
  [context check:^{
    [[expectThat(subscriber) receives] receive:message];
  }];
  
  [publisher publish:message];
  
  assertContextSatisfied(context);
}

```

The last line of our test will check that all expectations have been met and will cause a test failure if they have not.

So far, the only design decisions we've made so far is that a subscriber will be any object that implements the `Subscriber` protocol. For this test, we don't care what a particular implementation of `Subscriber` does with the message it receives. We've also begun to define our `Publisher` interface. 

### Getting it to compile

To get this code to compile, we'll need to define the Subscriber protocol and Publisher class. We can do this in our test file for now.

```objc
@protocol Subscriber

- (void)receives:(NSString *)message;

@end

@interface Publisher : NSObject

- (void)addSubscriber:(id<Subscriber>)subscriber;
- (void)publish:(NSString *)message;

@end

@implementation Publisher

- (void)addSubscriber:(id<Subscriber>)subscriber
{}
  
- (void)publish:(NSString *)message
{}

@end
```

Now we are able to compile our test, when we run it, it fails with the following error:

```
Expected <mock Subscriber> 
  to receive receive: with arguments: ["some message"] 
  exactly once but received it 0 times.
```

### Making the test pass

We can now write the simplest implementation possible to make this test work.

```objc
@implementation Publisher {
  id<Subscriber> _subscriber;
}

- (void)addSubscriber:(id<Subscriber>)subscriber
{
  _subscriber = subscriber;
}

- (void)publish:(NSString *)message
{
  [_subscriber receive:message];
}

@end
```

It's a quick first pass - we know we'll probably want to support multiple subscribers, but this should be enough to get the tests passing. We run them and they pass. 

### A second test

Let's see if we can write a test for multiple subscribers.

```objc
- (void)testMultipleSubscribersReceiveMessages
{
  id<Subscriber> subscriberOne = [context mock:@protocol(Subscriber)];
  id<Subscriber> subscriberTwo = [context mock:@protocol(Subscriber)];
    
  Publisher *publisher = [[Publisher alloc] init];
  [publisher addSubscriber:subscriberOne];
  [publisher addSubscriber:subscriberTwo];
  
  NSString *message = @"some message";
    
  [context check:^{
    [[expectThat(subscriberOne) receives] receive:message];
    [[expectThat(subscriberTwo) receives] receive:message];
  }];
  
  [publisher publish:message];
  
  assertContextSatisfied(context);
}

```

We expect this test to fail, and when we run it, we get the following error:

```
Expected <mock Subscriber> 
  to receive receive: with arguments: ["some message"] 
  exactly once but received it 0 times.
```

### Disambiguating the error message

This is what we expected to happen but there is one small issue: the error doesn't really help us identify which subscriber didn't receive the message. Let's give our mocks a custom name and try running it again:

```objc
- (void)testMultipleSubscribersReceiveMessages
{
  id<Subscriber> subscriberOne = [context mock:@protocol(Subscriber) 
                                         named:@"subscriber one"];
                                         
  id<Subscriber> subscriberTwo = [context mock:@protocol(Subscriber) 
                                         named:@"subscriber two"];
    
  ...
}

```

Now when we run the test, our error is a bit more useful:

```
Expected subscriber one 
  to receive receive: with arguments: ["some message"] 
  exactly once but received it 0 times.
```

Now we can update our implementation to get the test passing:

```objc
@implementation Publisher {
  NSMutableSet *_subscribers;
}

- (id)init
{
  self = [super init];
  if (self) {
    _subscribers = [[NSMutableSet alloc] init];
  }
  return self;
}

- (void)addSubscriber:(id<Subscriber>)subscriber
{
  [_subscribers addObject:subscriber];
}

- (void)publish:(NSString *)message
{
  [_subscribers makeObjectsPerformSelector:@selector(receive:) withObject:message];
}

@end
```

## Defining Expectations

All expectations in LRMocky are defined within an expectation block. An expectation block is defined by calling the `-[LRMockery check:]` method. 

The `check:` method can be called multiple times - the expectations from one block are appended to the expectations defined in any previous blocks.

All of the following code samples omit the `check:` block boilerplate and are assumed to be taking place within the context of the omitted block definition.

### Expectation syntax

The general form for expectations can be defined as follows:

```objc
[[expectThat(<mock object>) <cardinality-rule>] <selector-with-args>]; 
  [then <action>];
```

The `[then <action>]` part is optional and is used to define things that should happen when an expectation is met.
  
### Cardinality rules

All expectations have a cardinality, i.e. a number of calls that should happen for the expectation to be considered satisfied. The default cardinality for expectations is for them to be received exactly once. So the following:

```objc
[[expectThat(<mock object>) receives] someMethod];
```

Is the equivalent to:

```objc
[[expectThat(<mock object>) receivesExactly:1] someMethod];
```

You can expect a minimum number of invocations:

```objc
[[expectThat(<mock object>) receivesAtLeast:1] of] someMethod];
```

_(the above example uses the optional `of` method - this is purely syntatic sugar and may be used to suit your taste)_.

Or a maximum number of invocations:

```objc
[[expectThat(<mock object>) receivesAtMost:1] of] someMethod];
```

Or both:

```objc
[[expectThat(<mock object>) receivesBetween:1 and:3] of] someMethod];
```

If you don't care how many times a particular method is called - including no calls at all - you could write:

```objc
[[expectThat(<mock object>) receivesAtLeast:0] of] someMethod];
```

A better way of expressing this is to use the `allowing()` function in place of `expectThat()`.

```objc
[allowing(<mock object>) someMethod];
```

If you don't care what messages are sent to a mock object at all, you can ignore it entirely:

```objc
ignoring(<mock object>);
```

### Actions

Actions take place when an expectation is matched and successfully invoked. You could configure a method call to return a canned value (e.g. stubbing):

```objc
[allowing(<mock object>) returnsSomeString]; 
  [then returns:@"some string"];
```

If you need to return a primitive value, you can use `returnValue:` instead of `returns:`:

```objc
[allowing(<mock object>) returnsSomeInteger]; 
  [then returnsValue:(void *)123];
```

You'll notice the need to cast the value to a void pointer to prevent a compiler warning. Alternatively, you can pass a boxed value to `returns:` and it will still work as expected:

```objc
[allowing(<mock object>) returnsSomeInteger]; 
  [then returns:@123];
```

All of the above examples have been defined using `allowing()` instead of `expectThat()` - this is because you should prefer to stub queries, but only expect commands.

You can do more than return a value from an expected invocation. You can raise an exception:

```objc
[allowing(<mock object>) mightRaiseSomething]; 
  [then raisesException:<some exception>];
```
  
You can also perform an arbitrary block of code:

```objc
[allowing(<mock object>) returnsSomeString]; 
  [then performsBlock:^(NSInvocation *invocation) {
    // do something here
  }];
```

The matched invocation will always be passed into the block, giving you a chance to modify it if you wish (you could conditionally set the return value here, for instance).

You can also perform multiple actions:

```objc
[allowing(<mock object>) returnsSomeString]; 
  [then doesAllOf:^(id<LRExpectationActionSyntax> actions) {
    [actions returns:@"return value"];
    [actions performsBlock:^(NSInvocation *unused) {
      // do something else
    }];
  }];
```

If you are expecting multiple calls to a method, you could configure the expectation to perform different actions on each call. For instance, if you wanted to specify that the third call to a method raises an exception, you could write:

```objc
[allowing(<mock object>) returnsSomeString]; 
  [then onConsecutiveCalls:^(id<LRExpectationActionSyntax> actions) {
    [actions returns:@"return value 1"];
    [actions returns:@"return value 2"];
    [actions raisesException:<some exception>];
  }];
```

### States

Some times you want expectations to match only when in a particular state. This can be useful when testing that methods are only called in certain situations (normally after some other method call has taken place).

You can ask the mockery for a new state:

```objc
id readiness = [[context states:@"readiness"] startsAs:@"unready"];
```

We can use this state object within our expectation blocks to constraint expectations to only occur in the given state:

```objc
whenState([readiness equals:@"ready"], ^{
  [[expectThat(testObject) receives] someMethod];
});
```

If we were to call `someMethod` on `testObject` in the current state, an unexpected invocation error would be raised.

You can trigger a state transition by calling `transitionTo:` on the state object, but more typically you would trigger this as the result of another expectation, using a state transition action:

```objc
[[expectThat(testObject) receives] doSomethingElse]; 
  [then state:readiness becomes:@"ready"];
```

Now, as long as our object under test calls `doSomethingElse` before calling `doSomething`, the test will pass.
