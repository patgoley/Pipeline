//
//  ProducerPipeline.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/14/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

public final class ProducerPipeline<T>: ProducerType {
    
    public typealias OutputType = T
    
    private let head: Any
    
    private var tail: AnyConsumable<T>
    
    public var consumer: (OutputType -> Void)? {
        
        didSet {
            
            _setConsumer(consumer)
        }
    }
    
    private let _setConsumer: (T -> Void)? -> Void
    
    private let _produce: () -> Void
    
    public convenience init<Head: ProducerType where Head.OutputType == T>(head: Head) {
        
        let tail = AnyProducer(base: head)
        
        self.init(head: head, produce: head.produce, tail: tail)
    }
    
    private init<Tail: ConsumableType where Tail.OutputType == T>(head: Any, produce: () -> Void, tail: Tail) {
        
        self.head = head
        
        _produce = produce
        
        self.tail = AnyConsumable(base: tail)
        
        _setConsumer = { consumer in
            
            tail.consumer = consumer
        }
    }
    
    public func produce() {
        
        _produce()
    }
    
    public func then<Transform: TransformerType where Transform.InputType == OutputType>(transformer: Transform) -> ProducerPipeline<Transform.OutputType> {
        
        tail.consumer = transformer.consume
        
        return ProducerPipeline<Transform.OutputType>(head: head, produce: _produce, tail: transformer)
    }
    
    public func then<NewOutput>(transformer: OutputType -> NewOutput) -> ProducerPipeline<NewOutput> {
        
        let transform = AnyTransformer(transform: transformer)
        
        tail.consumer = transform.consume
        
        return ProducerPipeline<NewOutput>(head: head, produce: _produce, tail: transform)
    }
    
    public func finally<Consumer: ConsumerType where Consumer.InputType == OutputType>(consumer: Consumer) -> Self {
        
        self.consumer = consumer.consume
        
        return self
    }
    
    public func finally(consumer: OutputType -> Void) -> Self {
        
        self.consumer = consumer
        
        return self
    }
}


