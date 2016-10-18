//
//  ProducerPipeline.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/14/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

public final class ProducerPipeline<T>: Pipeline, ProducerType {
    
    public typealias OutputType = T
    
    let head: Producible
    
    var tail: AnyConsumable<T>
    
    public var consumer: ((OutputType) -> Void)? {
        
        didSet {
            
            _setConsumer(consumer)
        }
    }
    
    fileprivate let _setConsumer: (((T) -> Void)?) -> Void
    
    public convenience init<Head: ProducerType>(head: Head) where Head.OutputType == T {
        
        let tail = AnyConsumable(base: head)
        
        self.init(head: head, tail: tail)
    }
    
    init<Tail: ConsumableType>(head: Producible, tail: Tail) where Tail.OutputType == T {
        
        self.head = head
        
        self.tail = AnyConsumable(base: tail)
        
        _setConsumer = { consumer in
            
            tail.consumer = consumer
        }
    }
    
    public func produce() {
        
        head.produce()
    }
    
    public func finally<Consumer: ConsumerType>(_ consumer: Consumer) -> Producible where Consumer.InputType == OutputType {
        
        self.consumer = consumer.consume
        
        return self
    }
    
    public func finally(_ consumer: @escaping (OutputType) -> Void) -> Producible {
        
        self.consumer = consumer
        
        return self
    }
}


