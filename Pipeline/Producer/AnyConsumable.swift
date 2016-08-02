//
//  Consumable.swift
//  Pipeline
//
//  Created by Patrick Goley on 8/1/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public final class AnyConsumable<T>: TransformerType {
    
    public typealias InputType = Void
    
    public typealias OutputType = T
    
    public var consumer: (T -> Void)? {
        
        didSet {
            
            _setConsumer(consumer)
        }
    }
    
    private let _setConsumer: (T -> Void)? -> Void
    
    public init<Base: TransformerType where Base.OutputType == OutputType>(base: Base) {
        
        _setConsumer = { consumer in
            
            base.consumer = consumer
        }
    }
    
    public func consume(_: Void) {
        
        // NO-OP
    }
}
