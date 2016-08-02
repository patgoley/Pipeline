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
    
    public var consumer: ((OutputType) -> Void)? {
        
        didSet {
            
            _setConsumer(consumer)
        }
    }
    
    private let _consume: (InputType) -> Void
    
    private let _setConsumer: (OutputType -> Void)? -> Void
    
    public convenience init<Head: TransformerType where Head.InputType == InputType, Head.OutputType == OutputType>(head: Head) {
        
        let consume = { (value: InputType) in
            
            head.consume(value)
        }
        
        self.init(consume: consume, tail: head)
    }
    
    private init<Tail: TransformerType where Tail.OutputType == OutputType>(consume: (InputType) -> Void, tail: Tail) {
        
        _consume = consume
        
        _setConsumer = { (consumer: ((OutputType) -> Void)?) in
            
            tail.consumer = consumer
        }
    }

    
    public func consume(input: InputType) {
        
        _consume(input)
    }
    
    func then<Transform: TransformerType where Transform.InputType == OutputType>(transformer: Transform) -> Pipeline<InputType, Transform.OutputType> {
        
        consumer = transformer.consume
        
        return Pipeline<InputType, Transform.OutputType>(consume: consume, tail: transformer)
    }
    
    public func then<NewOutput>(transform: U -> NewOutput) -> Pipeline<InputType, NewOutput> {
        
        let transformer = ThunkTransformer(transform: transform)
        
        consumer = transformer.consume
        
        return Pipeline<InputType, NewOutput>(consume: consume, tail: transformer)
    }
}

public extension Pipeline {
    
    convenience init(head: InputType -> OutputType) {
        
        let transformer = ThunkTransformer(transform: head)
        
        self.init(head: transformer)
    }
}

