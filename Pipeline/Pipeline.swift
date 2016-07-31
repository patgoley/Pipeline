//
//  Pipeline.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/21/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

/*
 An empty type that is returned once a Pipeline has been fully
 constructed. This means the Pipeline begins with a ConsumableType
 and ends with a ConsumerType, which disallows any futher composition.
 The creator of the Pipeline should retain it as long as it needs to 
 function.
*/

public final class Pipeline<T, U>: TransformerType {
    
    public typealias InputType = T
    
    public typealias OutputType = U
    
    public var consumer: (OutputType -> Void)?
    
    private let _consume: (InputType) -> Void
    
    private let _setConsumer: (OutputType -> Void)? -> Void
    
    public convenience init<Head: TransformerType where Head.InputType == InputType, Head.OutputType == OutputType>(head: Head) {
        
        let setConsumer = { consumer in
         
            head.consumer = consumer
        }
        
        self.init(consume: head.consume, setConsumer: setConsumer)
    }
    
    public init(consume: (InputType) -> Void, setConsumer: (OutputType -> Void)? -> Void) {
        
        _consume = consume
        
        _setConsumer = setConsumer
    }
    
    public func consume(input: InputType) {
        
        _consume(input)
    }
    
    func then<Transform: TransformerType where Transform.InputType == OutputType>(transformer: Transform) -> Pipeline<InputType, Transform.OutputType> {
        
        _setConsumer(transformer.consume)
        
        let setConsumer = { consumer in
            
            transformer.consumer = consumer
        }
        
        return Pipeline<InputType, Transform.OutputType>(consume: _consume, setConsumer: setConsumer)
    }
    
    public func then<NewOutput>(transform: U -> NewOutput) -> Pipeline<InputType, NewOutput> {
        
        let transformer = ThunkTransformer(transform: transform)
        
        _setConsumer(transformer.consume)
        
        let setConsumer = { consumer in
            
            transformer.consumer = consumer
        }
        
        return Pipeline<InputType, NewOutput>(consume: _consume, setConsumer: setConsumer)
    }
}

public extension Pipeline {
    
    convenience init(head: InputType -> OutputType) {
        
        let transformer = ThunkTransformer(transform: head)
        
        self.init(head: transformer)
    }
}

