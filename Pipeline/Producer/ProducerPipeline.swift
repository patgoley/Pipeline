//
//  ProducerPipeline.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/14/16.
//  Copyright © 2016 patgoley. All rights reserved.
//

import Foundation

public final class ProducerPipeline<T>: Pipeline, ProducerType {
    
    public typealias OutputType = T
    
    private let head: Producible
    
    private var tail: AnyConsumable<T>
    
    public var consumer: (OutputType -> Void)? {
        
        didSet {
            
            _setConsumer(consumer)
        }
    }
    
    private let _setConsumer: (T -> Void)? -> Void
    
    public convenience init<Head: ProducerType where Head.OutputType == T>(head: Head) {
        
        let tail = AnyConsumable(base: head)
        
        self.init(head: head, tail: tail)
    }
    
    private init<Tail: ConsumableType where Tail.OutputType == T>(head: Producible, tail: Tail) {
        
        self.head = head
        
        self.tail = AnyConsumable(base: tail)
        
        _setConsumer = { consumer in
            
            tail.consumer = consumer
        }
    }
    
    public func produce() {
        
        head.produce()
    }
    
    public func then<Transform: TransformerType where Transform.InputType == OutputType>(transformer: Transform) -> ProducerPipeline<Transform.OutputType> {
        
        tail.consumer = transformer.consume
        
        return ProducerPipeline<Transform.OutputType>(head: head, tail: transformer)
    }
    
    public func then<NewOutput>(transformer: OutputType -> NewOutput) -> ProducerPipeline<NewOutput> {
        
        let transform = AnyTransformer(transform: transformer)
        
        tail.consumer = transform.consume
        
        return ProducerPipeline<NewOutput>(head: head, tail: transform)
    }
    
    public func finally<Consumer: ConsumerType where Consumer.InputType == OutputType>(consumer: Consumer) -> Producible {
        
        self.consumer = consumer.consume
        
        return self
    }
    
    public func finally(consumer: OutputType -> Void) -> Producible {
        
        self.consumer = consumer
        
        return self
    }
}


