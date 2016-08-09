//
//  AnyConsumer.swift
//  Pipeline
//
//  Created by Patrick Goley on 8/1/16.
//  Copyright © 2016 pipeline. All rights reserved.
//

import Foundation


public final class AnyConsumer<T>: TransformerType {
    
    public typealias InputType = T
    
    public typealias OutputType = Void
    
    private let _consume: InputType -> Void
    
    public var consumer: (OutputType -> Void)?
    
    public init(consume: T -> Void) {
        
        self._consume = consume
    }
    
    public init<Base: TransformerType where Base.InputType == T>(base: Base) {
        
        self._consume = base.consume
    }
    
    public func consume(input: InputType) {
        
        _consume(input)
        
        consumer?()
    }
}
