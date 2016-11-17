//
//  AnyTransformer.swift
//  Pipeline
//
//  Created by Patrick Goley on 11/16/16.
//  Copyright © 2016 arbiter. All rights reserved.
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
        
        guard let consumer = self.consumer else {
            
            return
        }
        
        let result = transform(input)
        
        consumer(result)
    }
}