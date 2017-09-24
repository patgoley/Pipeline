//
//  Consumable.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/19/16.
//

import Foundation


//TODO: Make all of these disposable?
public protocol ConsumableType: class {
    
    associatedtype OutputType
    
    var consumer: (OutputType -> Void)? { get set }
}


public extension ConsumableType {
    
    public func then<T>(map: (OutputType) -> T) -> ConsumablePipeline<T> {
        
        let transformer = AnyTransformer(transform: map)
        
        return then(transformer)
    }
    
    public func then<T: TransformerType where T.InputType == OutputType>(transformer: T) -> ConsumablePipeline<T.OutputType> {
    
        consumer = transformer.consume
        
        if let pipeline = self as? ConsumablePipeline<OutputType> {
        
            return ConsumablePipeline<T.OutputType>(head: pipeline.head, tail: transformer)
        
        } else {
        
            return ConsumablePipeline<T.OutputType>(head: AnyDisposable.create(self), tail: transformer)
        }
    }
    
    public func then<P: ProducerType>(transform: (OutputType) -> P) -> ConsumablePipeline<P.OutputType> {
        
        let transformer = FlatMapTransformer(flatMap: transform)
        
        return then(transformer)
    }
    
    public func then<C: ConsumableType>(transform: (OutputType) -> C) -> ConsumablePipeline<C.OutputType> {
        
        let transformer = FlatMapTransformer(flatMap: transform)
        
        return then(transformer)
    }
    
    public func finally<Consumer: ConsumerType where Consumer.InputType == OutputType>(consumer: Consumer) -> Pipeline {
        
        return finally(consumer.consume)
    }
    
    public func finally(consumer: OutputType -> Void) -> Pipeline {
        
        self.consumer = consumer
        
        return ConsumablePipeline(head: self)
    }
}