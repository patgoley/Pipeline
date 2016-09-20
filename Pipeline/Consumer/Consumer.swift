//
//  Consumer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public protocol ConsumerType: class {
    
    associatedtype InputType
    
    func consume(_: InputType)
}

public final class AnyConsumer<T>: ConsumerType {
    
    public typealias InputType = T
    
    fileprivate let _consume: (T) -> Void
    
    public init(consume: @escaping (T) -> Void) {
        
        self._consume = consume
    }
    
    public init<Base: ConsumerType>(base: Base) where Base.InputType == T {
        
        self._consume = base.consume
    }
    
    public func consume(_ input: T) {
        
        _consume(input)
    }
}
