//
//  FilterTransformer.swift
//  Pipeline
//
//  Created by Patrick Goley on 8/1/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


/*
 A transformer that only allows values meeting a given condition to be 
 passed along to the consumer.
*/

public final class FilterTransformer<T>: TransformerType  {
    
    public typealias InputType = T
    
    public typealias OutputType = T
    
    public var consumer: (OutputType -> Void)?
    
    public let condition: InputType -> Bool
    
    public init(condition: InputType -> Bool) {
        
        self.condition = condition
    }
    
    public func consume(input: InputType) {
        
        if condition(input) {
            
            consumer?(input)
        }
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
    
    public var consumer: (OutputType -> Void)?
    
    public let transform: InputType -> OutputType?
    
    public init(transform: InputType -> OutputType?) {
        
        self.transform = transform
    }
    
    public func consume(input: InputType) {
        
        if let result = transform(input) {
            
            consumer?(result)
        }
    }
}