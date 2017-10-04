//
//  Transformer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//

import Foundation


public protocol TransformerType: ConsumerType, ConsumableType { }


public extension TransformerType {
    
    public func then<Transform: TransformerType>(_ transformer: Transform) -> TransformerPipeline<InputType, Transform.OutputType> where Transform.InputType == OutputType {
        
        consumer = transformer.consume
    
        if let pipeline = self as? TransformerPipeline<InputType, OutputType> {
            
            return TransformerPipeline<InputType, Transform.OutputType>(head: pipeline.head, tail: transformer)
            
        } else {
            
            let head = AnyConsumer(base: self)
            
            return TransformerPipeline<InputType, Transform.OutputType>(head: head, tail: transformer)
        }
    }
    
    public func then<NewOutput>(_ transform: @escaping (OutputType) -> NewOutput) -> TransformerPipeline<InputType, NewOutput> {
        
        let transformer = AnyTransformer(transform: transform)
        
        consumer = transformer.consume
        
        if let pipeline = self as? TransformerPipeline<InputType, OutputType> {
            
            return TransformerPipeline<InputType, NewOutput>(head: pipeline.head, tail: transformer)
            
        } else {
            
            let head = AnyConsumer(base: self)
            
            return TransformerPipeline<InputType, NewOutput>(head: head, tail: transformer)
        }
    }
    
    public func finally<Consumer: ConsumerType>(_ consumer: Consumer) -> AnyConsumer<InputType> where Consumer.InputType == OutputType {
        
        return finally(consumer.consume)
    }
    
    public func finally(_ consumer: @escaping (OutputType) -> Void) -> AnyConsumer<InputType> {
        
        self.consumer = consumer
        
        return AnyConsumer(base: self)
    }
}
