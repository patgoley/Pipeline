//
//  Transformer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public protocol TransformerType: ConsumerType, ConsumableType { }

public final class AnyTransformer<T, U>: TransformerType  {
    
    public typealias InputType = T
    
    public typealias OutputType = U
    
    public var consumer: (OutputType -> Void)?
    
    public let transform: InputType -> OutputType
    
    public init(transform: InputType -> OutputType) {
        
        self.transform = transform
    }
    
    public func consume(input: InputType) {
        
        guard let consumer = self.consumer else {
            
            return
        }
        
        let result = transform(input)
        
        consumer(result)
    }
}

public final class OptionalFilterTransformer<T, U>: TransformerType  {
    
    public typealias InputType = T
    
    public typealias OutputType = U
    
    public var consumer: (OutputType -> Void)?
    
    public let transform: InputType -> OutputType?
    
    public init(transform: InputType -> OutputType?) {
        
        self.transform = transform
    }
    
    public func consume(input: InputType) {
        
        guard let consumer = self.consumer,
                  result = transform(input) else {
            
            return
        }
        
        consumer(result)
    }
}

public final class AsyncTransformer<T, U>: TransformerType  {
    
    public typealias InputType = T
    
    public typealias OutputType = U
    
    public var consumer: (OutputType -> Void)?
    
    public let execute: (InputType, (OutputType -> Void)) -> Void
    
    public init(execute: (InputType, (OutputType -> Void)) -> Void) {
        
        self.execute = execute
    }
    
    public func consume(input: InputType) {
        
        guard let consumer = self.consumer else {
            
            return
        }
        
        execute(input, consumer)
    }
}
