//
//  ConsumablePipeline.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/19/16.
//  Copyright © 2016 patgoley. All rights reserved.
//

import Foundation


public final class ConsumablePipeline<T>: Pipeline, ConsumableType {
    
    public typealias OutputType = T
    
    private let head: Any
    
    private let tail: AnyConsumable<T>
    
    public var consumer: (OutputType -> Void)? {
        
        didSet {
            
            _setConsumer(consumer)
        }
    }
    
    private let _setConsumer: (T -> Void)? -> Void
    
    public convenience init<Head: ConsumableType where Head.OutputType == T>(head: Head) {
        
        let tail = AnyConsumable(base: head)
        
        self.init(head: head, tail: tail)
    }
    
    private init<Tail: ConsumableType where Tail.OutputType == T>(head: Any, tail: Tail) {
        
        self.head = head
        
        self.tail = AnyConsumable(base: tail)
        
        _setConsumer = { consumer in
            
            tail.consumer = consumer
        }
    }
    
    public func then<Transform: TransformerType where Transform.InputType == OutputType>(transformer: Transform) -> ConsumablePipeline<Transform.OutputType> {
        
        tail.consumer = transformer.consume
        
        return ConsumablePipeline<Transform.OutputType>(head: head, tail: transformer)
    }
    
    public func then<NewOutput>(transformer: OutputType -> NewOutput) -> ConsumablePipeline<NewOutput> {
        
        let transform = AnyTransformer(transform: transformer)
        
        tail.consumer = transform.consume
        
        return ConsumablePipeline<NewOutput>(head: head, tail: transform)
    }
    
    public func finally<Consumer: ConsumerType where Consumer.InputType == OutputType>(consumer: Consumer) -> Pipeline {
        
        self.consumer = consumer.consume
        
        return self
    }
    
    public func finally(consumer: OutputType -> Void) -> Pipeline {
        
        self.consumer = consumer
        
        return self
    }
}


