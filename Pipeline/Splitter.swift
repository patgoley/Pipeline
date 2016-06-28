//
//  Splitter.swift
//  Pipeline
//
//  Created by Patrick Goley on 6/18/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public final class Splitter<T>: ConsumerType {
    
    public typealias InputType = T
    
    let consumers: [AnyConsumer<T>]
    
    init<C: ConsumerType where C.InputType == T>(consumers: [C]) {
        
        self.consumers = consumers.map(AnyConsumer.init)
    }
    
    public func consume(input: InputType) {
        
        for consumer in consumers {
            
            consumer.consume(input)
        }
    }
}

public func split<C: ConsumerType>(consumers: C...) -> Splitter<C.InputType> {
    
    return Splitter(consumers: consumers)
}

public func split<I>(consumerFunctions: (I) -> Void...) -> Splitter<I> {
    
    let consumers = consumerFunctions.map(AnyConsumer.init)
    
    return Splitter(consumers: consumers)
}

public func split<C: ConsumerType>(consumers: [C]) -> Splitter<C.InputType> {
    
    return Splitter(consumers: consumers)
}

public func split<I>(consumerFunctions: [(I) -> Void]) -> Splitter<I> {
    
    let consumers = consumerFunctions.map(AnyConsumer.init)
    
    return Splitter(consumers: consumers)
}
