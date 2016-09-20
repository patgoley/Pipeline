//
//  Consumable.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/19/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

public protocol ConsumableType: class {
    
    associatedtype OutputType
    
    var consumer: ((OutputType) -> Void)? { get set }
}


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
