//
//  Producer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

public protocol ProducerType {
    
    associatedtype OutputType
    
    var consumer: (OutputType -> Void)? { get set }
    
    func produce()
}

public final class AnyProducer<T>: ProducerType {
    
    public typealias OutputType = T
    
    public var consumer: (T -> Void)? {
        
        didSet {
            
            _setConsumer(consumer)
        }
    }
    
    private let _setConsumer: (T -> Void)? -> Void
    
    private let _produce: () -> Void
    
    init<Base: ProducerType where Base.OutputType == OutputType>(base: Base) {
        
        _produce = base.produce
        
        var mutableBase = base
        
        _setConsumer = { consumer in
            
            mutableBase.consumer = consumer
        }
    }
    
    private func consume(input: T) -> Void {
        
        consumer?(input)
    }
    
    public func produce() {
        
        _produce()
    }
}


