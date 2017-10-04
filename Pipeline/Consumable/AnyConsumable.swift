//
//  AnyConsumable.swift
//  Pipeline
//
//  Created by Patrick Goley on 11/16/16.
//

import Foundation


public final class AnyConsumable<T>: ConsumableType {
    
    public typealias OutputType = T
    
    public var consumer: ((T) -> Void)? {
        
        didSet {
            
            _setConsumer(consumer)
        }
    }
    
    fileprivate let _setConsumer: (((T) -> Void)?) -> Void
    
    public init<Base: ConsumableType>(base: Base) where Base.OutputType == OutputType {
        
        _setConsumer = { consumer in
            
            base.consumer = consumer
        }
    }
}
