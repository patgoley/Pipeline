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


extension ProducerType {
    
    func then<T>(_ map: @escaping (OutputType) -> T) -> ProducerPipeline<T> {
        
        let transformer = AnyTransformer(transform: map)
        
        return then(transformer)
    }
    
    func then<T: TransformerType>(_ transformer: T) -> ProducerPipeline<T.OutputType> where T.InputType == OutputType {
        
        self.consumer = transformer.consume
        
        if let pipeline = self as? ProducerPipeline<OutputType> {
            
            return ProducerPipeline<T.OutputType>(head: pipeline.head, tail: transformer)
            
        } else {
            
            return ProducerPipeline<T.OutputType>(head: self, tail: transformer)
        }
    }
    
    public func then<P: ProducerType>(_ function: @escaping (OutputType) -> P) -> ProducerPipeline<P.OutputType> {
        
        let transformer = AsyncTransformer<OutputType, P.OutputType>() { input, consumer in
            
            let producer = function(input)
            
            producer.produce(consumer)
        }
        
        consumer = transformer.consume
        
        return then(transformer)
    }
}
