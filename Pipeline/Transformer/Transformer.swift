//
//  Transformer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//

import Foundation


public protocol TransformerType: ConsumerType, ConsumableType { }


public extension TransformerType {
    
    public func then<Transform: TransformerType where Transform.InputType == OutputType>(transformer: Transform) -> TransformerPipeline<InputType, Transform.OutputType> {
        
        consumer = transformer.consume
    
        if let pipeline = self as? TransformerPipeline<InputType, OutputType> {
            
            return TransformerPipeline<InputType, Transform.OutputType>(head: pipeline.head, tail: transformer)
            
        } else {
            
            let head = AnyConsumer(base: self)
            
            return TransformerPipeline<InputType, Transform.OutputType>(head: head, tail: transformer)
        }
    }
    
    public func then<NewOutput>(transform: OutputType -> NewOutput) -> TransformerPipeline<InputType, NewOutput> {
        
        let transformer = AnyTransformer(transform: transform)
        
        consumer = transformer.consume
        
        if let pipeline = self as? TransformerPipeline<InputType, OutputType> {
            
            return TransformerPipeline<InputType, NewOutput>(head: pipeline.head, tail: transformer)
            
        } else {
            
            let head = AnyConsumer(base: self)
            
            return TransformerPipeline<InputType, NewOutput>(head: head, tail: transformer)
        }
    }
    
    public func finally<Consumer: ConsumerType where Consumer.InputType == OutputType>(consumer: Consumer) -> AnyConsumer<InputType> {
        
        return finally(consumer.consume)
    }
    
    public func finally(consumer: OutputType -> Void) -> AnyConsumer<InputType> {
        
        self.consumer = consumer
        
        return AnyConsumer(base: self)
    }
}