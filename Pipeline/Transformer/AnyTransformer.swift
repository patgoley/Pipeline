//
//  AnyTransformer.swift
//  Pipeline
//
//  Created by Patrick Goley on 11/16/16.
//

import Foundation


/*
 A type erasure class for TransformerType. Users of this class
 only need to provide the function for transforming values,
 AnyTransformer implements TransformerType and uses the provided
 function for transforming values.
 */

public final class AnyTransformer<T, U>: TransformerType  {
    
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