//
//  Transformer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public protocol TransformerType: ConsumerType, ConsumableType { }

extension TransformerType {
    
    func then<T>(_ map: @escaping (OutputType) -> T) -> TransformerPipeline<InputType, T> {
        
        let transformer = AnyTransformer(transform: map)
        
        return then(transformer)
    }
    
    func then<T: TransformerType>(_ transformer: T) -> TransformerPipeline<InputType, T.OutputType> where T.InputType == OutputType {
        
        self.consumer = transformer.consume
        
        if let pipeline = self as? TransformerPipeline<InputType, OutputType> {
            
            return TransformerPipeline<InputType, T.OutputType>(head: pipeline.head, tail: transformer)
            
        } else {
            
            return TransformerPipeline(head: AnyConsumer(base: self), tail: transformer)
        }
    }
    
    public func finally<Consumer: ConsumerType>(_ consumer: Consumer) -> AnyConsumer<InputType> where Consumer.InputType == OutputType {
        
        self.consumer = consumer.consume
        
        return AnyConsumer(base: self)
    }
    
    public func finally(_ consumer: @escaping (OutputType) -> Void) -> AnyConsumer<InputType> {
        
        self.consumer = consumer
        
        return AnyConsumer(base: self)
    }
}
