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
    
    var consumer: (OutputType -> Void)? { get set }
}


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

public final class AsyncConsumable<T>: ConsumableType {
    
    public typealias OutputType = T
    
    public var consumer: (T -> Void)?
    
    public init(start: ((T) -> Void) -> Void) {
        
        let listen = { (value: T) -> Void in
            
            self.consumer?(value)
        }
        
        start(listen)
    }
}