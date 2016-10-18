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

extension ConsumableType {
    
    func then<T>(_ map: @escaping (OutputType) -> T) -> ConsumablePipeline<T> {
        
        let transformer = AnyTransformer(transform: map)
        
        return then(transformer)
    }
    
    func then<T: TransformerType>(_ transformer: T) -> ConsumablePipeline<T.OutputType> where T.InputType == OutputType {
        
        self.consumer = transformer.consume
        
        if let pipeline = self as? ConsumablePipeline<OutputType> {
            
            return ConsumablePipeline<T.OutputType>(head: pipeline.head, tail: transformer)
            
        } else {
            
            return ConsumablePipeline<T.OutputType>(head: self, tail: transformer)
        }
    }
    
    public func then<P: ProducerType>(_ function: @escaping (OutputType) -> P) -> ConsumablePipeline<P.OutputType> {
        
        let transformer = AsyncTransformer<OutputType, P.OutputType>() { input, consumer in
            
            let producer = function(input)
            
            producer.produce(consumer)
        }
        
        consumer = transformer.consume
        
        return then(transformer)
    }
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
