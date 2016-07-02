# Pipeline

[![Build Status](https://travis-ci.org/patgoley/Pipeline.svg?branch=master)](https://travis-ci.org/patgoley/Pipeline) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Hex.pm](https://img.shields.io/hexpm/l/plug.svg?maxAge=2592000)]()

 
Pipeline is a framework that empowers functional programming in Swift. It chains together values, functions, and objects that act like functions into "pipelines" that produce, transform, or consume data. 

Objects! Isn't that functional heresy? It can be, but there's no reason we can't have objects that are just as pure and wonderful as functions. This is possible through a few simple protocols provided by Pipeline. Each one corresponds to an equivalent function type, and Pipeline generally treats the two as interchangeable. It's less important how we implement things (with functions or objects), and more important that we think in terms of **input** and **output**.

Let's take a look at the first of our protocols, `ConsumableType`. 


``` swift
protocol ConsumableType {
    
    associatedtype OutputType
    
    var consumer: (OutputType -> Void)? { get set }
}
```
A `ConsumableType` is something that produces some kind of output, the type of which is determined by `OutputType`. The `consumer` variable is a function to which new values created by the `ConsumableType` should be passed. You can think of `consumer` like a listener block that someone else will provide if they want to receive values from this `ConsumableType`.

Now we said each protocol had a function type equivalent, so let's see the functional form of `ConsumableType`.

``` swift
() -> T
```

Here we have a function that produces a value when called. Conceptually this is similar to the `ConsumableType` protocol above in that we have a thing that creates output.

The compliment to a `ConsumableType` is a `ConsumerType`. It receives some kind of input, which is determined by its `InputType`. It has a function called `consume` to receive incoming values and carry out some work with them. Consumers can be hooked up to consumables as long as their `InputType` and `OutputType` match.

``` swift
protocol ConsumerType {
    
    associatedtype InputType
    
    func consume(_: InputType) -> Void
}
```

The functional equivalent of `ConsumerType` is easy to guess. It is the most basic function type that takes some kind of input and does something with it. 

``` swift
T -> ()
```


The last of the main protocols is `TransformerType`, which is both a `ConsumerType` and a `ConsumableType`. It's job is to take incoming values and transform them to some other type and pass them to its own consumer. The same rules apply to `TransformerType` as it's constituent protocols, its `InputType` must match the output of a consumable, and its `OutputType` must match the input of a receiving consumer.

``` swift
protocol TransformerType: ConsumerType, ConsumableType { }
```

The functional version of `TransformerType` also a combination of the function types of the other two protocols. It takes some input value and transforms it to some different output value, which may or may not be of the same type.

``` swift
T -> U
```

The goal of Pipeline is to allow you to express the components of your application as one of these protocols or function types, and then string them together in various ways to create complex functionality. It strongly suggests that each component should do *exactly* one thing, which allows maximum reusability. It's also flexible in that each component can be an object or a function, depending on what's convenient.

Now that we've established the kinds of components we can make, let's look at how to string them together. Here are some stubbed functions and objects that we could use to get some JSON data from the web.

``` swift
func requestforURL(url: NSURL) -> NSURLRequest {
    ...
}

class HTTPClient: TransformerType {

    typealias InputType = NSURLRequest

    typealias OutputType = NSHTTPURLResponse

    ...
}

func dataFromResponse(response: NSHTTPURLResponse) -> NSData {
    ...
}

func JSONObjectFromData(data: NSData) -> [String: AnyObject] {
    ...
}

```

You can probably imagine the implementations of these components without much trouble, each one is meant to be simple and only do one thing. So how can we string these together with Pipeline? Like so!

``` swift
let getObjectPipeline = requestforURL |> HTTPClient() |> dataFromResponse |> JSONObjectFromData

//getObjectPipeline is TransformerPipeline<NSURL, [String, AnyObject]>
```

So after chaining these components together, we end up with a `TransformerPipeline`. This pipeline is nothing special really, just `TransformerType` that takes in an `NSURL` and ultimately produces a `[String: AnyObject]`, using the functions and object we strung together to create it. We can use it just like any transformer:

``` swift
getObjectPipeline.consumer = { (json: [String: AnyObject]) in

    print("Houston we have some json! \(json)")
}

let url = NSURL(string: "http://json-api.com/get-some-object")

getObjectPipeline.consume(url)

// or the short hand version

getObjectPipeline.consume(url) { json in 

    print("much json \(json)")
}

```

What's great about the pipeline just being a `TransformerType` is that we can chain it up to any function, object, or pipeline that produces an `NSURL` or that consumes a `[String: AnyObject]`. This allows us to make things that are reusable based on their input or output type, instead of having some unique interface that must be glued together with other interfaces using extra code.

This is the essence of functional programming, to think about your app as a stream of values that are created in one place, travel along a series of transformations and are ultimately consumed by something. Pipeline provides scaffolding for connecting components together so you can focus on solving real problems, one at a time, and not waste time writing and refactoring glue code.

# License 

Pipeline is available under the Apache 2 License. See the LICENSE file for more info.