# Pipeline

[![Build Status](https://travis-ci.org/patgoley/Pipeline.svg?branch=master)](https://travis-ci.org/patgoley/Pipeline) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

 
Pipeline is a framework that facilitates functional programming in Swift. It chains together values, functions, and types that act like functions into "pipelines" that produce, transform, or consume data.

There are three main protocols that underly the types in Pipeline. The first one we'll look at is `ConsumableType`. 


``` swift
protocol ConsumableType {
    
    associatedtype OutputType
    
    var consumer: (OutputType -> Void)? { get set }
}
```
A `ConsumableType` is something that produces values of a particular type and passes it to a consumer function. Other types can "hook into" the `ConsumableType` by setting it's consumer to a function, which will then be called whenever a new value is available.

The compliment to a `ConsumableType` is a `ConsumerType`. It has an input type and a function to receive incoming values. Consumers can be hooked up to Consumables as long as their `InputType` and `OutputType` match.

``` swift
protocol ConsumerType {
    
    associatedtype InputType
    
    func consume(_: InputType) -> Void
}
```

The last of the main protocols is `TransformerType`, which is both a ConsumerType and a ConsumableType. It's job is to take incoming values and transform them to some other type and pass them to it's own consumer.

``` swift
protocol TransformerType: ConsumerType, ConsumableType { }
```

The goal of Pipeline is to allow you to express pieces of your application as one of these three types, and then string them together in various ways to create complex functionality. It strongly suggests that each type should do *exactly* one thing, which allows maximum reusability. 

# License 

Pipeline is available under the Apache 2 License. See the LICENSE file for more info.