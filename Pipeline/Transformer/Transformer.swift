//
//  Transformer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 pipeline. All rights reserved.
//

import Foundation


public protocol TransformerType: ProducerType, ConsumerType {
    

}

/*
 A type erasure class for TransformerType. This can be used to abstract
 any implementation of TransformerType.
 */

public final class AnyTransformer<T, U>: TransformerType  {
    
    public typealias InputType = T
    
    public typealias OutputType = U
    
    public var consumer: (OutputType -> Void)? {
        
        didSet {
            
            _setConsumer(consumer)
        }
    }
    
    private let _consume: (InputType) -> Void
    
    private let _setConsumer: (OutputType -> Void)? -> Void
    
    public init<Base: TransformerType where Base.InputType == T, Base.OutputType == U>(base: Base) {
        
        _consume = base.consume
        
        _setConsumer = { consumer in
            
            base.consumer = consumer
        }
    }
    
    public func consume(input: InputType) {

        _consume(input)
    }
}

/*
 An implemenation of TransformerType using the function passed to init.
*/

public final class ThunkTransformer<T, U>: TransformerType  {
    
    public typealias InputType = T
    
    public typealias OutputType = U
    
    public var consumer: (OutputType -> Void)?
    
    public let transform: InputType -> OutputType
    
    public init(transform: InputType -> OutputType) {
        
        self.transform = transform
    }
    
    public func consume(input: InputType) {
        
        let result = transform(input)
        
        consumer?(result)
    }
}

/* 
 A transformer that provides a way to observe incoming values
 and pass them along. Useful for when you want to use a consumer
 to process something (perhaps log a value to the console) but
 don't want to terminate the Pipeline.
*/

public final class PassThroughTransformer<T>: TransformerType  {
    
    public typealias InputType = T
    
    public typealias OutputType = T
    
    public var consumer: (OutputType -> Void)?
    
    public let observe: InputType -> Void
    
    public init(observe: InputType -> Void) {
        
        self.observe = observe
    }
    
    public func consume(input: InputType) {
        
        observe(input)
        
        consumer?(input)
    }
}

/*
 Encapsulates an asynchronous transformer operation. Users of this
 class must provide a function that takes an input and a completion
 closure for the output
*/

public final class AsyncTransformer<T, U>: TransformerType  {
    
    public typealias InputType = T
    
    public typealias OutputType = U
    
    public var consumer: (OutputType -> Void)?
    
    public let execute: (InputType, (OutputType -> Void)) -> Void
    
    public init(execute: (InputType, (OutputType -> Void)) -> Void) {
        
        self.execute = execute
    }
    
    public func consume(input: InputType) {
        
        execute(input) { [weak self] (value: OutputType) in
         
            self?.consumer?(value)
        }
    }
}

