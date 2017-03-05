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
    
    public func then<Transform: TransformerType>(_ transformer: Transform) -> ProducerPipeline<Transform.OutputType> where Transform.InputType == OutputType {
        
        consumer = transformer.consume
        
        if let pipeline = self as? ProducerPipeline<Transform.OutputType> {
            
            return ProducerPipeline<Transform.OutputType>(head: pipeline.head, tail: transformer)
            
        } else {
            
            return ProducerPipeline<Transform.OutputType>(head: self, tail: transformer)
        }
    }
    
    public func then<NewOutput>(_ transform: @escaping (OutputType) -> NewOutput) -> ProducerPipeline<NewOutput> {
        
        let transformer = AnyTransformer(transform: transform)
        
        consumer = transformer.consume
        
        if let pipeline = self as? ProducerPipeline<NewOutput> {
            
            return ProducerPipeline<NewOutput>(head: pipeline.head, tail: transformer)
            
        } else {
            
            return ProducerPipeline<NewOutput>(head: self, tail: transformer)
        }
    }
    
    public func finally<Consumer: ConsumerType>(_ consumer: Consumer) -> Producible where Consumer.InputType == OutputType {
        
        return finally(consumer.consume)
    }
    
    public func finally(_ consume: @escaping (OutputType) -> Void) -> Producible {
        
        self.consumer = consume
        
        if self is ProducerPipeline<OutputType> {
            
            return self
            
        } else {
            
            return ProducerPipeline<OutputType>(head: self)
        }
    }
}


