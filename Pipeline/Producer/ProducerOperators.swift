//
//  ProducerOperators.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/24/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

// Creation

public func |> <P: ProducerType, U: TransformerType where P.OutputType == U.InputType>(lhs: P, rhs: U) -> ProducerPipeline<U.OutputType>  {
    
    return lhs.then(rhs)
}
public func |> <P: ProducerType, U>(lhs: P, rhs: P.OutputType -> U) -> ProducerPipeline<U>  {
    
    return lhs.then(rhs)
}

public func |> <V, T: TransformerType where V == T.InputType>(lhs: () -> V, rhs: T) -> ProducerPipeline<T.OutputType>  {
    
    let producer = ThunkProducer(thunk: lhs)
    
    return producer.then(rhs)
}

public func |> <V, T>(lhs: () -> V, rhs: V -> T) -> ProducerPipeline<T>  {
    
    let producer = ThunkProducer(thunk: lhs)
    
    return producer.then(rhs)
}

// Finally

public func |> <P: ProducerType, C: ConsumerType where C.InputType == P.OutputType>(lhs: P, rhs: C) -> Producible  {
    
    return lhs.finally(rhs)
}

public func |> <P: ProducerType>(lhs: P, rhs: P.OutputType -> Void) -> Producible  {
    
    return lhs.finally(rhs)
}


// Throwing

public func |> <P: ProducerType, U>(lhs: P, rhs: P.OutputType throws -> U) -> ProducerPipeline<Result<U>>  {
    
    let throwingTransform = map(rhs)
    
    return lhs.then(throwingTransform)
}

public func |> <V, T: TransformerType where T.InputType == Result<V>>(lhs: () throws -> V, rhs: T) -> ProducerPipeline<T.OutputType>  {
    
    let throwingProduce = map(lhs)
    
    let producer = ThunkProducer(thunk: throwingProduce)
    
    return producer.then(rhs)
}

public func |> <V, T>(lhs: () throws -> V, rhs: Result<V> -> T) -> ProducerPipeline<T>  {
    
    let throwingProduce = map(lhs)
    
    let producer = ThunkProducer(thunk: throwingProduce)
    
    return producer.then(rhs)
}
