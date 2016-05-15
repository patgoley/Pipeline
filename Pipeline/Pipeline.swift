//
//  Pipeline.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/14/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

public struct GeneratorPipeline<T>: ProducerType {
    
    public typealias OutputType = T
    
    private let head: Any
    
    private let tail: AnyProducer<T>
    
    public var consumer: (OutputType -> Void)?
    
    public init<Head: ProducerType where Head.OutputType == T>(head: Head) {
        
        self.init(head: head, tail: head)
    }
    
    private init<Tail: ProducerType where Tail.OutputType == T>(head: Any, tail: Tail) {
        
        self.head = head
        
        var producer = AnyProducer(base: tail)
        
        self.tail = producer
        
        producer.consumer = { input in
            
            self.consumer?(input)
        }
    }
    
    func then<Transform: TransformerType where Transform.InputType == OutputType>(transformer: Transform) -> GeneratorPipeline<Transform.OutputType> {
        
        var tail = self.tail
        
        tail.consumer = transformer.consume
        
        return GeneratorPipeline<Transform.OutputType>(head: head, tail: transformer)
    }
}

public struct TransformerPipeline<T, U>: TransformerType {
    
    public typealias InputType = T
    
    public typealias OutputType = U
    
    public var consumer: (OutputType -> Void)?
    
    private let head: AnyConsumer<T>
    
    private let tail: AnyProducer<U>
    
    public init<Head: TransformerType where Head.InputType == InputType, Head.OutputType == OutputType>(head: Head) {
        
        self.init(head: head, tail: head)
    }
    
    private init<Head: ConsumerType, Tail: ProducerType where Head.InputType == InputType, Tail.OutputType == OutputType>(head: Head, tail: Tail) {
        
        self.head = AnyConsumer(base: head)
        
        var tailProducer = AnyProducer(base: tail)
        
        self.tail = tailProducer
        
        tailProducer.consumer = { input in
            
            self.consumer?(input)
        }
    }
    
    public func consume(input: InputType) {
        
        head.consume(input)
    }
    
    func then<Transform: TransformerType where Transform.InputType == OutputType>(transformer: Transform) -> TransformerPipeline<InputType, Transform.OutputType> {
        
        var tail = self.tail
        
        tail.consumer = transformer.consume
        
        return TransformerPipeline<T, Transform.OutputType>(head: head, tail: transformer)
    }
    
    func then<NewOutput>(transformer: U -> NewOutput) -> TransformerPipeline<InputType, NewOutput> {
        
        var tail = self.tail
        
        let transform = AnyTransformer(consumer: nil, transform: transformer)
        
        tail.consumer = transform.consume
        
        return TransformerPipeline<InputType, NewOutput>(head: head, tail: transform)
    }
}

