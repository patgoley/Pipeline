//
//  ValueProducer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/16/16.
//

import Foundation


public final class ValueProducer<T>: ProducerType {
    
    let value: T
    
    public var consumer: ((T) -> Void)?
    
    public init(_ value: T) {
        
        self.value = value
    }
    
    public func produce() {
        
        consumer?(value)
    }
}

public final class ThunkProducer<T>: ProducerType {
    
    let thunk: () -> T
    
    public var consumer: ((T) -> Void)?
    
    public init(thunk: @escaping () -> T) {
        
        self.thunk = thunk
    }
    
    public func produce() {
        
        let value = thunk()
        
        consumer?(value)
    }
}
