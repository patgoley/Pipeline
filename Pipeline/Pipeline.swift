//
//  Pipeline.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/21/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

/*
 A type that is constructed from composing any combination of TransformerTypes or functions 
*/

public final class Pipeline<T, U>: TransformerType {
    
    public typealias InputType = T
    
    public typealias OutputType = U
    
    public var consumer: (OutputType -> Void)? {
        
        didSet {
            
            _setConsumer(consumer)
        }
    }
    
    private let _setConsumer: (OutputType -> Void)? -> Void
    
    private let head: AnyConsumer<InputType>
    
    private let tail: AnyConsumable<OutputType>
    
    public convenience init<Head: TransformerType where Head.InputType == InputType, Head.OutputType == OutputType>(head: Head) {
        
        let headConsumer = AnyConsumer(base: head)
        
        self.init(head: headConsumer, tail: head)
    }
    
    private init<Tail: TransformerType where Tail.OutputType == OutputType>(head: AnyConsumer<InputType>, tail: Tail) {
        
        self.head = head
        
        self.tail = AnyConsumable(base: tail)
        
        _setConsumer = { consumer in
            
            tail.consumer = consumer
        }
    }

    
    public func consume(input: InputType) {
        
        head.consume(input)
    }
    
    func then<Transform: TransformerType where Transform.InputType == OutputType>(transformer: Transform) -> Pipeline<InputType, Transform.OutputType> {
        
        tail.consumer = transformer.consume
        
        return Pipeline<InputType, Transform.OutputType>(head: head, tail: transformer)
    }
    
    public func then<NewOutput>(transformer: U -> NewOutput) -> Pipeline<InputType, NewOutput> {
        
        let transform = ThunkTransformer(transform: transformer)
        
        tail.consumer = transform.consume
        
        return Pipeline<InputType, NewOutput>(head: head, tail: transform)
    }

}

public extension Pipeline {
    
    convenience init(head: InputType -> OutputType) {
        
        let transformer = ThunkTransformer(transform: head)
        
        self.init(head: transformer)
    }
}

