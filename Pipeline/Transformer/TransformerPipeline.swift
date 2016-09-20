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
    
    fileprivate let head: AnyConsumer<InputType>
    
    fileprivate let tail: AnyConsumable<OutputType>
    
    public convenience init<Head: TransformerType>(head: Head) where Head.InputType == InputType, Head.OutputType == OutputType {
        
        let headConsumer = AnyConsumer(base: head)
        
        self.init(head: headConsumer, tail: head)
    }
    
    fileprivate init<Tail: TransformerType>(head: AnyConsumer<InputType>, tail: Tail) where Tail.OutputType == OutputType {
        
        self.head = head
        
        self.tail = AnyConsumable(base: tail)
        
        _setConsumer = { consumer in
            
            tail.consumer = consumer
        }
    }
    
    public func consume(_ input: InputType) {
        
        head.consume(input)
    }
    
    func then<Transform: TransformerType>(_ transformer: Transform) -> TransformerPipeline<InputType, Transform.OutputType> where Transform.InputType == OutputType {
        
        tail.consumer = transformer.consume
        
        return TransformerPipeline<InputType, Transform.OutputType>(head: head, tail: transformer)
    }
    
    public func then<NewOutput>(_ transformer: @escaping (U) -> NewOutput) -> TransformerPipeline<InputType, NewOutput> {
        
        let transform = AnyTransformer(transform: transformer)
        
        tail.consumer = transform.consume
        
        return TransformerPipeline<InputType, NewOutput>(head: head, tail: transform)
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
