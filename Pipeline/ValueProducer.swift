//
//  ValueProducer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/16/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public final class ValueProducer<T>: ProducerType {
    
    let value: T
    
    public var consumer: (T -> Void)?
    
    init(value: T) {
        
        self.value = value
    }
    
    public func produce() {
        
        consumer?(value)
    }
}

public final class ThunkProducer<T>: ProducerType {
    
    let thunk: () -> T
    
    public var consumer: (T -> Void)?
    
    init(thunk: () -> T) {
        
        self.thunk = thunk
    }
    
    public func produce() {
        
        let value = thunk()
        
        consumer?(value)
    }
}
