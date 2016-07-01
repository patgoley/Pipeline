//
//  ProducerOperators.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/24/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public func |> <P: ProducerType, U: TransformerType where P.OutputType == U.InputType>(lhs: P, rhs: U) -> ProducerPipeline<U.OutputType>  {
    
    return ProducerPipeline(head: lhs).then(rhs)
}

public func |> <P: ProducerType, U>(lhs: P, rhs: P.OutputType -> U) -> ProducerPipeline<U>  {
    
    return ProducerPipeline(head: lhs).then(rhs)
}

public func |> <V, T: TransformerType where V == T.InputType>(lhs: () -> V, rhs: T) -> ProducerPipeline<T.OutputType>  {
    
    let thunkProducer = ThunkProducer(thunk: lhs)
    
    return ProducerPipeline(head: thunkProducer).then(rhs)
}

public func |> <V, T>(lhs: () -> V, rhs: V -> T) -> ProducerPipeline<T>  {
    
    let thunkProducer = ThunkProducer(thunk: lhs)
    
    return ProducerPipeline(head: thunkProducer).then(rhs)
}

// pipeline chaining

public func |> <O, C>(lhs: ProducerPipeline<O>, rhs: O -> C) -> ProducerPipeline<C>  {
    
    return lhs.then(rhs)
}

public func |> <O, T where T: TransformerType, O == T.InputType>(lhs: ProducerPipeline<O>, rhs: T) -> ProducerPipeline<T.OutputType>  {
    
    return lhs.then(rhs)
}

// throwing

public func |> <P: ProducerType, U>(lhs: P, rhs: P.OutputType throws -> U) -> ProducerPipeline<Result<U>>  {
    
    let throwingTransform = map(rhs)
    
    return ProducerPipeline(head: lhs).then(throwingTransform)
}

public func |> <O, C>(lhs: ProducerPipeline<O>, rhs: O throws -> C) -> ProducerPipeline<Result<C>>  {
    
    let throwingTransform = map(rhs)
    
    return lhs.then(throwingTransform)
}

public func |> <V, T: TransformerType where T.InputType == Result<V>>(lhs: () throws -> V, rhs: T) -> ProducerPipeline<T.OutputType>  {
    
    let throwingProduce = map(lhs)
    
    let producer = ThunkProducer(thunk: throwingProduce)
    
    return ProducerPipeline(head: producer).then(rhs)
}

public func |> <V, T>(lhs: () throws -> V, rhs: Result<V> -> T) -> ProducerPipeline<T>  {
    
    let throwingProduce = map(lhs)
    
    let producer = ThunkProducer(thunk: throwingProduce)
    
    return ProducerPipeline(head: producer).then(rhs)
}

// finally

public func |> <P: ProducerType>(lhs: P, rhs: P.OutputType -> Void) -> Producible  {
    
    return ProducerPipeline(head: lhs).finally(rhs)
}

public func |> <O, C: ConsumerType where C.InputType == O>(lhs: ProducerPipeline<O>, rhs: C) -> Producible  {
    
    return lhs.finally(rhs)
}

public func |> <O>(lhs: ProducerPipeline<O>, rhs: O -> Void) -> Producible  {
    
    return lhs.finally(rhs)
}

public func |> <P: ProducerType, C: ConsumerType where C.InputType == P.OutputType>(lhs: P, rhs: C) -> Producible  {
    
    return ProducerPipeline(head: lhs).finally(rhs)
}

