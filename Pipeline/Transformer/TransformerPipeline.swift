//
//  TransformerPipeline.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/19/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public final class TransformerPipeline<T, U>: Pipeline, TransformerType {
    
    public typealias InputType = T
    
    public typealias OutputType = U
    
    public var consumer: ((OutputType) -> Void)? {
        
        didSet {
            
            _setConsumer(consumer)
        }
    }
    
    fileprivate let _setConsumer: (((OutputType) -> Void)?) -> Void
    
    let head: AnyConsumer<InputType>
    
    let tail: AnyConsumable<OutputType>
    
    public convenience init<Head: TransformerType>(head: Head) where Head.InputType == InputType, Head.OutputType == OutputType {
        
        let headConsumer = AnyConsumer(base: head)
        
        self.init(head: headConsumer, tail: head)
    }
    
    init<Tail: TransformerType>(head: AnyConsumer<InputType>, tail: Tail) where Tail.OutputType == OutputType {
        
        self.head = head
        
        self.tail = AnyConsumable(base: tail)
        
        _setConsumer = { consumer in
            
            tail.consumer = consumer
        }
    }
    
    public func consume(_ input: InputType) {
        
        head.consume(input)
    }
    
    public func finally<Consumer: ConsumerType>(_ consumer: Consumer) -> AnyConsumer<InputType> where Consumer.InputType == OutputType {
        
        self.consumer = consumer.consume
        
        return AnyConsumer(base: self)
    }
    
    public func finally(_ consumer: @escaping (OutputType) -> Void) -> AnyConsumer<InputType> {
        
        self.consumer = consumer
        
        return AnyConsumer(base: self)
    }
}

public extension TransformerPipeline {
    
    convenience init(head: @escaping (InputType) -> OutputType) {
        
        let transformer = AnyTransformer(transform: head)
        
        self.init(head: transformer)
    }
}
