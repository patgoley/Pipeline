//
//  ValueProducer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/16/16.
//  Copyright © 2016 patgoley. All rights reserved.
//

import Foundation


public final class ValueProducer<T>: ProducerType {
    
    let value: T
    
    public var consumer: (T -> Void)?
    
    public init(_ value: T) {
        
        self.value = value
    }
    
    public func produce() {
        
        consumer?(value)
    }
}

public final class ThunkProducer<T>: ProducerType {
    
    let thunk: () -> T
    
    public var consumer: (T -> Void)?
    
    public init(thunk: () -> T) {
        
        self.thunk = thunk
    }
    
    public func produce() {
        
        if let consumer = consumer {
            
            let value = thunk()
            
            consumer(value)
        }
    }
}