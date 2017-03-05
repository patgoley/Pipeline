//
//  ConsumablePipeline.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/19/16.
//

import Foundation


public final class ConsumablePipeline<T>: Pipeline, ConsumableType {
    
    public typealias OutputType = T
    
    let head: Any
    
    let tail: AnyConsumable<T>
    
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
    
    init<Tail: ConsumableType>(head: Any, tail: Tail) where Tail.OutputType == T {
        
        self.head = head
        
        self.tail = AnyConsumable(base: tail)
        
        _setConsumer = { consumer in
            
            tail.consumer = consumer
        }
    }
}


