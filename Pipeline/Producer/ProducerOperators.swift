//
//  ProducerOperators.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/24/16.
//

import Foundation

// Creation

public func |> <P: ProducerType, U: TransformerType>(lhs: P, rhs: U) -> ProducerPipeline<U.OutputType> where P.OutputType == U.InputType  {
    
    return lhs.then(rhs)
}

public func |> <P: ProducerType, U>(lhs: P, rhs: @escaping (P.OutputType) -> U) -> ProducerPipeline<U>  {
    
    return lhs.then(rhs)
}

public func |> <V, T: TransformerType>(lhs: @escaping () -> V, rhs: T) -> ProducerPipeline<T.OutputType> where V == T.InputType  {
    
    let producer = ThunkProducer(thunk: lhs)
    
    return producer.then(rhs)
}

public func |> <V, T>(lhs: @escaping () -> V, rhs: @escaping (V) -> T) -> ProducerPipeline<T>  {
    
    let producer = ThunkProducer(thunk: lhs)
    
    return producer.then(rhs)
}

// Finally

public func |> <P: ProducerType, C: ConsumerType>(lhs: P, rhs: C) -> Producible where C.InputType == P.OutputType  {
    
    return lhs.finally(rhs)
}

public func |> <P: ProducerType>(lhs: P, rhs: @escaping (P.OutputType) -> Void) -> Producible  {
    
    return lhs.finally(rhs)
}


// Throwing

public func |> <P: ProducerType, U>(lhs: P, rhs: @escaping (P.OutputType) throws -> U) -> ProducerPipeline<Result<U>>  {
    
    let throwingTransform = map(rhs)
    
    return lhs.then(throwingTransform)
}

public func |> <V, T: TransformerType>(lhs: @escaping () throws -> V, rhs: T) -> ProducerPipeline<T.OutputType> where T.InputType == Result<V>  {
    
    let throwingProduce = map(lhs)
    
    let producer = ThunkProducer(thunk: throwingProduce)
    
    return producer.then(rhs)
}

public func |> <V, T>(lhs: @escaping () throws -> V, rhs: @escaping (Result<V>) -> T) -> ProducerPipeline<T>  {
    
    let throwingProduce = map(lhs)
    
    let producer = ThunkProducer(thunk: throwingProduce)
    
    return producer.then(rhs)
}
