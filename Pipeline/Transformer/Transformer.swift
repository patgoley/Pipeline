//
//  Transformer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public protocol TransformerType: ConsumerType, ConsumableType { }

/*
 A type erasure class for TransformerType. Users of this class
 only need to provide the function for transforming values,
 AnyTransformer implements TransformerType and uses the provided
 function for transforming values.
*/

public final class AnyTransformer<T, U>: TransformerType  {
    
    public typealias InputType = T
    
    public typealias OutputType = U
    
    public var consumer: (U -> Void)?
    
    public let transform: T -> U
    
    public init(transform: T -> U) {
        
        self.transform = transform
    }
    
    public func consume(input: T) {
        
        guard let consumer = self.consumer else {
            
            return
        }
        
        let result = transform(input)
        
        consumer(result)
    }
}


/*
 A transformer that filters values not meeting a certain condition. 
 If a value is encountered that doesn't meet the condition, the
 execution of the Pipeline ends (no value is passed to the consumer).
*/

public final class FilterTransformer<T>: TransformerType  {
    
    public typealias InputType = T
    
    public typealias OutputType = T
    
    public var consumer: (T -> Void)?
    
    public let condition: T -> Bool
    
    public init(condition: T -> Bool) {
        
        self.condition = condition
    }
    
    public func consume(input: T) {
        
        guard let consumer = self.consumer where condition(input) else {
                
                return
        }
        
        consumer(input)
    }
}

/*
 A transformer that attempts to unwrap optionals and pass along
 the unwrapped valued. If nil is encountered, the execution of the
 Pipeline ends (no value is passed to the consumer).
*/

public final class OptionalFilterTransformer<T, U>: TransformerType  {
    
    public typealias InputType = T
    
    public typealias OutputType = U
    
    public var consumer: (U -> Void)?
    
    public let transform: T -> U?
    
    public init(transform: T -> U?) {
        
        self.transform = transform
    }
    
    public func consume(input: T) {
        
        guard let consumer = self.consumer,
                  result = transform(input) else {
            
            return
        }
        
        consumer(result)
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
    
    public var consumer: (T -> Void)?
    
    public let observe: T -> Void
    
    public init(observe: T -> Void) {
        
        self.observe = observe
    }
    
    public func consume(input: T) {
        
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
    
    public var consumer: (U -> Void)?
    
    public let execute: (T, (U -> Void)) -> Void
    
    public init(execute: (T, (U -> Void)) -> Void) {
        
        self.execute = execute
    }
    
    public func consume(input: T) {
        
        guard let consumer = self.consumer else {
            
            return
        }
        
        execute(input, consumer)
    }
}


