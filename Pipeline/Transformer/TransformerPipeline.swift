//
//  TransformerPipeline.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/19/16.
//

import Foundation


public final class TransformerPipeline<T, U>: Pipeline, TransformerType {
    
    public typealias InputType = T
    
    public typealias OutputType = U
    
    public var consumer: (OutputType -> Void)? {
        
        didSet {
            
            _setConsumer(consumer)
        }
    }
    
    private let _setConsumer: (OutputType -> Void)? -> Void
    
    let head: AnyConsumer<InputType>
    
    let tail: AnyConsumable<OutputType>
    
    public convenience init<Head: TransformerType where Head.InputType == InputType, Head.OutputType == OutputType>(head: Head) {
        
        let headConsumer = AnyConsumer(base: head)
        
        self.init(head: headConsumer, tail: head)
    }
    
    init<Tail: TransformerType where Tail.OutputType == OutputType>(head: AnyConsumer<InputType>, tail: Tail) {
        
        self.head = head
        
        self.tail = AnyConsumable(base: tail)
        
        _setConsumer = { consumer in
            
            tail.consumer = consumer
        }
    }
    
    public func consume(input: InputType) {
        
        head.consume(input)
    }
}

public extension TransformerPipeline {
    
    convenience init(head: InputType -> OutputType) {
        
        let transformer = AnyTransformer(transform: head)
        
        self.init(head: transformer)
    }
}
