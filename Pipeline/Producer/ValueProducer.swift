//
//  ValueProducer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/16/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public final class ValueProducer<T>: TransformerType {
    
    public typealias InputType = Void
    
    let value: T
    
    public var consumer: (T -> Void)?
    
    public init(_ value: T) {
        
        self.value = value
    }
    
    public func consume(_: Void) {
        
        consumer?(value)
    }
    
    public func produce() {
        
        consumer?(value)
    }
}

