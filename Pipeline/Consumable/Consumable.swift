//
//  Consumable.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/19/16.
//

import Foundation

public protocol ConsumableType: class {
    
    associatedtype OutputType
    
    var consumer: ((OutputType) -> Void)? { get set }
}


public extension ConsumableType {
    
    public func then<T>(_ map: @escaping (OutputType) -> T) -> ConsumablePipeline<T> {
        
        let transformer = AnyTransformer(transform: map)
        
        return then(transformer)
    }
    
    public func then<T: TransformerType>(_ transformer: T) -> ConsumablePipeline<T.OutputType> where T.InputType == OutputType {
    
        consumer = transformer.consume
        
        if let pipeline = self as? ConsumablePipeline<OutputType> {
        
            return ConsumablePipeline<T.OutputType>(head: pipeline.head, tail: transformer)
        
        } else {
        
            return ConsumablePipeline<T.OutputType>(head: self, tail: transformer)
        }
    }
    
    public func finally<Consumer: ConsumerType>(_ consumer: Consumer) -> Pipeline where Consumer.InputType == OutputType {
        
        return finally(consumer.consume)
    }
    
    public func finally(_ consumer: @escaping (OutputType) -> Void) -> Pipeline {
        
        self.consumer = consumer
        
        return ConsumablePipeline(head: self)
    }
}
