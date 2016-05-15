//
//  Transformer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public protocol TransformerType: ConsumerType, ProducerType { }

public struct AnyTransformer<T, U>: TransformerType  {
    
    public typealias InputType = T
    
    public typealias OutputType = U
    
    public var consumer: (OutputType -> Void)?
    
    private let _transform: InputType -> OutputType
    
    public init(consumer: (OutputType -> Void)? = nil, transform: InputType -> OutputType) {
        
        self._transform = transform
        
        self.consumer = consumer
    }
    
    public init<C: ConsumerType where C.InputType == U>(consumer: C, transform: InputType -> OutputType) {
        
        self.init(consumer: consumer.consume, transform: transform)
    }
    
    public func consume(input: InputType) {
        
        if let consumer = self.consumer {
            
            let result = transform(input)
            
            consumer(result)
        }
    }
    
    public func transform(input: T) -> U {
        
        return _transform(input)
    }
}