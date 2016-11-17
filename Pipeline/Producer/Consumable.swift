//
//  Consumable.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/19/16.
//

import Foundation

public protocol ConsumableType: class {
    
    associatedtype OutputType
    
    var consumer: (OutputType -> Void)? { get set }
}


extension ConsumableType {
    
    func then<T>(map: (OutputType) -> T) -> ConsumablePipeline<T> {
        
        let transformer = AnyTransformer(transform: map)
        
        return then(transformer)
    }
    
    func then<T: TransformerType where T.InputType == OutputType>(transformer: T) -> ConsumablePipeline<T.OutputType> {
    
        self.consumer = transformer.consume
        
        if let pipeline = self as? ConsumablePipeline<OutputType> {
        
            return ConsumablePipeline<T.OutputType>(head: pipeline.head, tail: transformer)
        
        } else {
        
            return ConsumablePipeline<T.OutputType>(head: self, tail: transformer)
        }
    }
    
    public func finally<Consumer: ConsumerType where Consumer.InputType == OutputType>(consumer: Consumer) -> Pipeline {
        
        self.consumer = consumer.consume
        
        return ConsumablePipeline(head: self)
    }
    
    public func finally(consumer: OutputType -> Void) -> Pipeline {
        
        self.consumer = consumer
        
        return ConsumablePipeline(head: self)
    }
}