//
//  Splitter.swift
//  Pipeline
//
//  Created by Patrick Goley on 6/18/16.
//

import Foundation


public final class Splitter<T>: ConsumerType {
    
    public typealias InputType = T
    
    let consumers: [AnyConsumer<T>]
    
    init<C: ConsumerType>(consumers: [C]) where C.InputType == T {
        
        self.consumers = consumers.map(AnyConsumer.init)
    }
    
    public func consume(_ input: InputType) {
        
        for consumer in consumers {
            
            consumer.consume(input)
        }
    }
}

public func split<C: ConsumerType>(_ consumers: C...) -> Splitter<C.InputType> {
    
    return Splitter(consumers: consumers)
}

public func split<I>(_ consumerFunctions: (I) -> Void...) -> Splitter<I> {
    
    let consumers = consumerFunctions.map(AnyConsumer.init)
    
    return Splitter(consumers: consumers)
}

public func split<C: ConsumerType>(_ consumers: [C]) -> Splitter<C.InputType> {
    
    return Splitter(consumers: consumers)
}

public func split<I>(_ consumerFunctions: [(I) -> Void]) -> Splitter<I> {
    
    let consumers = consumerFunctions.map(AnyConsumer.init)
    
    return Splitter(consumers: consumers)
}
