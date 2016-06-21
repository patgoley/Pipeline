//
//  Producer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

public protocol Producible: class {
    
    func produce()
}

public protocol ProducerType: ConsumableType, Producible { }

public final class AnyProducer<T>: ProducerType {
    
    public typealias OutputType = T
    
    public var consumer: (T -> Void)? {
        
        didSet {
            
            _setConsumer(consumer)
        }
    }
    
    private let _setConsumer: (T -> Void)? -> Void
    
    private let _produce: () -> Void
    
    public init<Base: ProducerType where Base.OutputType == OutputType>(base: Base) {
        
        _produce = base.produce
        
        _setConsumer = { consumer in
            
            base.consumer = consumer
        }
    }
    
    public func produce() {
        
        _produce()
    }
}

final class AsyncProducer<T>: ProducerType {
    
    typealias OutputType = T
    
    var consumer: (T -> Void)?
    
    let _produce: (T -> Void) -> Void
    
    init(produce: (T -> Void) -> Void) {
        
        _produce = produce
    }
    
    func produce() {
        
        guard let consumer = self.consumer else {
            
            return
        }
        
        _produce() { output in
            
            consumer(output)
        }
    }
}


