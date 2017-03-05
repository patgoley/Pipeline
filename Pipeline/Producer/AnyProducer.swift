//
//  AnyProducer.swift
//  Pipeline
//
//  Created by Patrick Goley on 11/16/16.
//

import Foundation


public final class AnyProducer<T>: ProducerType {
    
    public typealias OutputType = T
    
    public var consumer: ((T) -> Void)? {
        
        didSet {
            
            _setConsumer(consumer)
        }
    }
    
    fileprivate let _setConsumer: (((T) -> Void)?) -> Void
    
    fileprivate let _produce: () -> Void
    
    public init<Base: ProducerType>(base: Base) where Base.OutputType == OutputType {
        
        _produce = base.produce
        
        _setConsumer = { consumer in
            
            base.consumer = consumer
        }
    }
    
    public func produce() {
        
        _produce()
    }
}
