//
//  ProducerOperators.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/24/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

// Creation

public func |> <P: ProducerType, U: TransformerType>(lhs: P, rhs: U) -> ProducerPipeline<U.OutputType> where P.OutputType == U.InputType  {
    
    return ProducerPipeline(head: lhs).then(rhs)
}
public func |> <P: ProducerType, U>(lhs: P, rhs: @escaping (P.OutputType) -> U) -> ProducerPipeline<U>  {
    
    return ProducerPipeline(head: lhs).then(rhs)
}

public func |> <V, T: TransformerType>(lhs: @escaping () -> V, rhs: T) -> ProducerPipeline<T.OutputType> where V == T.InputType  {
    
    let thunkProducer = ThunkProducer(thunk: lhs)
    
    return ProducerPipeline(head: thunkProducer).then(rhs)
}

public func |> <V, T>(lhs: @escaping () -> V, rhs: @escaping (V) -> T) -> ProducerPipeline<T>  {
    
    let thunkProducer = ThunkProducer(thunk: lhs)
    
    return ProducerPipeline(head: thunkProducer).then(rhs)
}

public func |> <V, T: TransformerType>(lhs: @escaping () throws -> V, rhs: T) -> ProducerPipeline<T.OutputType> where T.InputType == Result<V>  {
    
    let throwingProduce = map(lhs)
    
    let producer = ThunkProducer(thunk: throwingProduce)
    
    return ProducerPipeline(head: producer).then(rhs)
}

public func |> <V, T>(lhs: @escaping () throws -> V, rhs: @escaping (Result<V>) -> T) -> ProducerPipeline<T>  {
    
    let throwingProduce = map(lhs)
    
    let producer = ThunkProducer(thunk: throwingProduce)
    
    return ProducerPipeline(head: producer).then(rhs)
}

// Chaining

public func |> <O, T>(lhs: ProducerPipeline<O>, rhs: T) -> ProducerPipeline<T.OutputType> where T: TransformerType, O == T.InputType  {
    
    return lhs.then(rhs)
}

public func |> <O, C>(lhs: ProducerPipeline<O>, rhs: @escaping (O) -> C) -> ProducerPipeline<C>  {
    
    return lhs.then(rhs)
}

public func |> <Input, NewOutput>(lhs: ProducerPipeline<Input>, rhs: @escaping (Input) throws -> NewOutput) -> ProducerPipeline<Result<NewOutput>>  {
    
    let resultFunction = map(rhs)
    
    return lhs.then(resultFunction)
}

// Finally

public func |> <P: ProducerType, C: ConsumerType>(lhs: P, rhs: C) -> Producible where C.InputType == P.OutputType  {
    
    return ProducerPipeline(head: lhs).finally(rhs)
}

public func |> <P: ProducerType, U>(lhs: P, rhs: @escaping (P.OutputType) throws -> U) -> ProducerPipeline<Result<U>>  {
    
    let throwingTransform = map(rhs)
    
    return ProducerPipeline(head: lhs).then(throwingTransform)
}

public func |> <P: ProducerType>(lhs: P, rhs: @escaping (P.OutputType) -> Void) -> Producible  {
    
    return ProducerPipeline(head: lhs).finally(rhs)
}

public func |> <O, C: ConsumerType>(lhs: ProducerPipeline<O>, rhs: C) -> Producible where C.InputType == O  {
    
    return lhs.finally(rhs)
}

public func |> <O>(lhs: ProducerPipeline<O>, rhs: @escaping (O) -> Void) -> Producible  {
    
    return lhs.finally(rhs)
}

