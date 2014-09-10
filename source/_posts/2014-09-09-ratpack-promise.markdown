---
layout: post
title: "Ratpack Promise"
date: 2014-09-09 15:33:46 -0500
comments: true
categories:
- Ratpack
- Groovy
---
Ratpack has a core class that is the center of the great asynchronous support, [Promise](http://www.ratpack.io/manual/current/api/index.html?ratpack/exec/Promise.html).

Ratpack Promises are very easy to work with, there are just a few key points:

 * Only attach to a promise one time
 * If dealing with the error case it must be done before the success case


``` groovy Consuming Value from Promise
Promise promise = somethingThatReturnsPromise()

promise.then {
  println it
}
```

What we are doing here is giving a closure to the promise that once the value is ready the closure will be called with the value passed in as a parameter. We can also be very explicit in what we are getting back from the promise.

``` groovy Explicit Value from Promise
def p = httpClient.get {
  it.url.set(new URI("http://example.com"))
}

p.then { ReceivedResponse receivedResponse ->
  println receivedResponse.statusCode
}
```
So for this works great when dealing with the happy path but we also need to deal with failures to fulfill the promise. So to do this we start with `onError` instead of `then`.

``` groovy Ratpack Promise with Failure Path
httpClient.get {
    it.url.set(new URI("http://example.com"))
} onError {
    println "Something when wrong: ${it.message}"
} then {
    render "Got a ${it.statusCode} status with body of:\n\n${it.body.text}"
}
```
`onError` will pass in a throwable to the closure that you can log or do whatever work you would like in the case of a failure.

## What not to do

You shouldn't try to attach more than once to a Promise. So don't do the following:

``` groovy Don't do this

def p = httpClient.get {
  it.url.set(new URI("http://example.com"))
}

p.onError {
  println it
}

p.then {
  println it.statusCode
}

```
