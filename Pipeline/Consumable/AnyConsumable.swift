//
//  AnyConsumable.swift
//  Pipeline
//
//  Created by Patrick Goley on 11/16/16.
//

import Foundation


public final class AnyConsumable<T>: ConsumableType {
    
    public typealias OutputType = T
    
    public var consumer: (T -> Void)? {
        
        didSet {
            
            _setConsumer(consumer)
        }
    }
    
    private let _setConsumer: (T -> Void)? -> Void
    
    public init<Base: ConsumableType where Base.OutputType == OutputType>(base: Base) {
        
        _setConsumer = { consumer in
            
            base.consumer = consumer
        }
    }
}