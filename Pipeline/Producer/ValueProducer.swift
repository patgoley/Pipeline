//
//  ValueProducer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/16/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public final class ValueProducer<T>: ProducerType {
    
    public typealias OutputType = T
    
    public var consumer: ((OutputType) -> Void)?
    
    let value: T
    
    public init(_ value: T) {
        
        self.value = value
    }
    
    public func produce() {
        
        consumer?(value)
    }
}

public final class ThunkProducer<T>: ProducerType {
    
    public typealias OutputType = T
    
    public var consumer: ((OutputType) -> Void)?
    
    let thunk: () -> T
    
    public init(thunk: @escaping () -> T) {
        
        self.thunk = thunk
    }
    
    public func produce() {
        
        if let consumer = consumer {
            
            let value = thunk()
            
            consumer(value)
        }
    }
}
