//
//  ConsumablePipeline.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/19/16.
//

import Foundation


public final class ConsumablePipeline<T>: Pipeline, ConsumableType, Disposable {
    
    public typealias OutputType = T
    
    let head: Disposable
    
    let tail: AnyConsumable<T>
    
    public var consumer: (OutputType -> Void)? {
        
        didSet {
            
            tail.consumer = consumer
        }
    }
    
    public convenience init<Head: ConsumableType where Head.OutputType == T>(head: Head) {
        
        let disposableHead = AnyDisposable(head)
        
        let tail = AnyConsumable(base: head)
        
        self.init(head: disposableHead, tail: tail)
    }
    
    public convenience init<Head: ConsumableType where Head: Disposable, Head.OutputType == T>(head: Head) {
        
        let tail = AnyConsumable(base: head)
        
        self.init(head: head, tail: tail)
    }
    
    init<Tail: ConsumableType where Tail.OutputType == T>(head: Disposable, tail: Tail) {
        
        self.head = head
        
        self.tail = tail as? AnyConsumable<T> ?? AnyConsumable(base: tail)
    }
    
    public func dispose() {
        
        tail.consumer = nil
        
        head.dispose()
    }
}


