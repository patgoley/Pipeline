//
//  Producer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//

import Foundation

public protocol Producible: class {
    
    func produce()
}

public protocol ProducerType: ConsumableType, Producible { }

extension ProducerType {
    
    public func then<Transform: TransformerType where Transform.InputType == OutputType>(transformer: Transform) -> ProducerPipeline<Transform.OutputType> {
        
        consumer = transformer.consume
        
        if let pipeline = self as? ProducerPipeline<Transform.OutputType> {
            
            return ProducerPipeline<Transform.OutputType>(head: pipeline.head, tail: transformer)
            
        } else {
            
            return ProducerPipeline<Transform.OutputType>(head: self, tail: transformer)
        }
    }
    
    public func then<NewOutput>(transform: OutputType -> NewOutput) -> ProducerPipeline<NewOutput> {
        
        let transformer = AnyTransformer(transform: transform)
        
        consumer = transformer.consume
        
        if let pipeline = self as? ProducerPipeline<NewOutput> {
            
            return ProducerPipeline<NewOutput>(head: pipeline.head, tail: transformer)
            
        } else {
            
            return ProducerPipeline<NewOutput>(head: self, tail: transformer)
        }
    }
    
    public func finally<Consumer: ConsumerType where Consumer.InputType == OutputType>(consumer: Consumer) -> Producible {
        
        return finally(consumer.consume)
    }
    
    public func finally(consume: OutputType -> Void) -> Producible {
        
        self.consumer = consume
        
        if self is ProducerPipeline<OutputType> {
            
            return self
            
        } else {
            
            return ProducerPipeline<OutputType>(head: self)
        }
    }
}


