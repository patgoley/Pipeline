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

public final class AnyProducer<T>: ProducerType {
    
    public typealias OutputType = T
    
    public var consumer: (T -> Void)? {
        
        didSet {
            
            _setConsumer(consumer)
        }
    }
    
    private let _setConsumer: (T -> Void)? -> Void
    
    init<Base: ProducerType where Base.OutputType == OutputType>(base: Base) {
        
        var mutableBase = base
        
        _setConsumer = { consumer in
            
            mutableBase.consumer = consumer
        }
    }
    
    private func consume(input: T) -> Void {
        
        consumer?(input)
    }
}

extension ProducerType {
    
    mutating func finally<Consumer: ConsumerType where Consumer.InputType == OutputType>(consumer: Consumer) -> Self {
        
        self.consumer = consumer.consume
        
        return self
    }
    
    mutating func finally(consumer: OutputType -> Void) -> Self {
        
        self.consumer = consumer
        
        return self
    }
}

protocol DiscreteProducer: ProducerType {
    
    func produce()
}

protocol ContinuousProducer: ProducerType {
    
    func start()
    
    func stop()
}


