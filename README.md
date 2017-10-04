# Pipeline

[![Build Status](https://travis-ci.org/patgoley/Pipeline.svg?branch=master)](https://travis-ci.org/patgoley/Pipeline) [![CocoaPods](https://img.shields.io/cocoapods/v/Pipeline.svg)]() [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Hex.pm](https://img.shields.io/hexpm/l/plug.svg?maxAge=2592000)]()

# Overview

Pipeline is a framework that empowers functional programming in Swift. It chains together functions and objects into "pipelines" that produce, transform, or consume data in a linear fashion.

Take the following components that make up a very basic networking library:


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

So after chaining these components together, we end up with a `TransformerPipeline`. This pipeline is nothing special really, just `TransformerType` that takes in an `NSURL` and ultimately produces a `[String: AnyObject]`, using the functions and object we strung together to create it. Let's use this pipeline to get some JSON from Reddit.

``` swift

let url = NSURL(string: "https://www.reddit.com/r/science.json")

getObjectPipeline.consume(url) { json in

    print("science subreddit object: \(json)")
}

```

What's great about the pipeline just being a `TransformerType` is that we can chain it up to any function, object, or pipeline that produces an `NSURL` or that consumes a `[String: AnyObject]`. This allows us to make things that are reusable based on their input or output type, instead of having some unique interface that must be glued together with other interfaces using extra code.

# Installation

``` ruby

pod 'Pipeline', '~> 2.0'

```

# License

Pipeline is available under the Apache 2 License. See the LICENSE file for more info.
