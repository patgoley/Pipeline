//
//  AnyConsumer.swift
//  Pipeline
//
//  Created by Patrick Goley on 11/16/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public final class AnyConsumer<T>: ConsumerType {
    
    public typealias InputType = T
    
    private let _consume: T -> Void
    
    public init(consume: T -> Void) {
        
        self._consume = consume
    }
    
    public init<Base: ConsumerType where Base.InputType == T>(base: Base) {
        
        self._consume = base.consume
    }
    
    public func consume(input: T) {
        
        _consume(input)
    }
}