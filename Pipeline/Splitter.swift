//
//  Splitter.swift
//  Pipeline
//
//  Created by Patrick Goley on 6/18/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public final class Splitter<T>: TransformerType {
    
    public typealias InputType = T
    
    public typealias OutputType = T
    
    let consumers: [AnyConsumer<T>]
    
    public var consumer: (InputType -> Void)?
    
    init<Transformer: TransformerType where Transformer.InputType == T>(transformers: [Transformer]) {
        
        self.consumers = transformers.map(AnyConsumer.init)
    }
    
    init(consumers: [AnyConsumer<T>]) {
        
        self.consumers = consumers
    }
    
    public func consume(input: InputType) {
        
        for consumer in consumers {
            
            consumer.consume(input)
        }
        
        consumer?(input)
    }
}

public func split<T: TransformerType>(transformers: T...) -> Splitter<T.InputType> {
    
    return Splitter(transformers: transformers)
}

public func split<I>(consumerFunctions: (I) -> Void...) -> Splitter<I> {
    
    let consumers = consumerFunctions.map(AnyConsumer.init)
    
    return Splitter(consumers: consumers)
}

public func split<T: TransformerType>(transformers: [T]) -> Splitter<T.InputType> {
    
    return Splitter(transformers: transformers)
}

public func split<I>(consumerFunctions: [(I) -> Void]) -> Splitter<I> {
    
    let consumers = consumerFunctions.map(AnyConsumer.init)
    
    return Splitter(consumers: consumers)
}
