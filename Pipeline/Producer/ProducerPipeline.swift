//
//  ProducerPipeline.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/14/16.
//

import Foundation

public final class ProducerPipeline<T>: Pipeline, ProducerType {
    
    public typealias OutputType = T
    
    let head: Producible
    
    var tail: AnyConsumable<T>
    
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
    
    init<Tail: ConsumableType where Tail.OutputType == OutputType>(head: Producible, tail: Tail) {
        
        self.head = head
        
        self.tail = AnyConsumable(base: tail)
        
        _setConsumer = { consumer in
            
            tail.consumer = consumer
        }
    }
    
    public func produce() {
        
        head.produce()
    }
}


