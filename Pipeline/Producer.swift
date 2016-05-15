//
//  Producer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

public protocol ProducerType {
    
    associatedtype OutputType
    
    var consumer: (OutputType -> Void)? { get set }
}

public struct AnyProducer<T>: ProducerType {
    
    public typealias OutputType = T
    
    public var consumer: (T -> Void)?
    
    private let captureBlock: () -> Void
    
    init<Base: ProducerType where Base.OutputType == OutputType>(base: Base) {
        
        captureBlock = {
            
            let _ = base
        }
        
        var mutableBase = base
        
        mutableBase.consumer = self.consume
    }
    
    private func consume(input: T) -> Void {
        
        consumer?(input)
    }
}