//
//  ConsumablePipeline.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/19/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public final class ConsumablePipeline<T>: Pipeline, ConsumableType {
    
    public typealias OutputType = T
    
    fileprivate let head: Any
    
    fileprivate let tail: AnyConsumable<T>
    
    public var consumer: ((OutputType) -> Void)? {
        
        didSet {
            
            _setConsumer(consumer)
        }
    }
    
    fileprivate let _setConsumer: (((T) -> Void)?) -> Void
    
    public convenience init<Head: ConsumableType>(head: Head) where Head.OutputType == T {
        
        let tail = AnyConsumable(base: head)
        
        self.init(head: head, tail: tail)
    }
    
    fileprivate init<Tail: ConsumableType>(head: Any, tail: Tail) where Tail.OutputType == T {
        
        self.head = head
        
        self.tail = AnyConsumable(base: tail)
        
        _setConsumer = { consumer in
            
            tail.consumer = consumer
        }
    }
    
    public func then<Transform: TransformerType>(_ transformer: Transform) -> ConsumablePipeline<Transform.OutputType> where Transform.InputType == OutputType {
        
        tail.consumer = transformer.consume
        
        return ConsumablePipeline<Transform.OutputType>(head: head, tail: transformer)
    }
    
    public func then<NewOutput>(_ transformer: @escaping (OutputType) -> NewOutput) -> ConsumablePipeline<NewOutput> {
        
        let transform = AnyTransformer(transform: transformer)
        
        tail.consumer = transform.consume
        
        return ConsumablePipeline<NewOutput>(head: head, tail: transform)
    }
    
    public func finally<Consumer: ConsumerType>(_ consumer: Consumer) -> Pipeline where Consumer.InputType == OutputType {
        
        self.consumer = consumer.consume
        
        return self
    }
    
    public func finally(_ consumer: @escaping (OutputType) -> Void) -> Pipeline {
        
        self.consumer = consumer
        
        return self
    }
}


