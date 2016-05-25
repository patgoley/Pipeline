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
    
    let pipe = ProducerPipeline(head: lhs)
    
    return pipe.then(rhs)
}

public func |> <O, C where C: TransformerType, O == C.InputType>(lhs: ProducerPipeline<O>, rhs: C) -> ProducerPipeline<C.OutputType>  {
    
    return lhs.then(rhs)
}

public func |> <V, T: TransformerType where V == T.InputType>(lhs: () -> V, rhs: T) -> ProducerPipeline<T.OutputType>  {
    
    let thunkProducer = ThunkProducer(thunk: lhs)
    
    return ProducerPipeline(head: thunkProducer).then(rhs)
}

public func |> <V, T>(lhs: () -> V, rhs: V -> T) -> ProducerPipeline<T>  {
    
    let thunkProducer = ThunkProducer(thunk: lhs)
    
    return ProducerPipeline(head: thunkProducer).then(rhs)
}

public func |> <O, C>(lhs: ProducerPipeline<O>, rhs: O -> C) -> ProducerPipeline<C>  {
    
    return lhs.then(rhs)
}

public func |> <P: ProducerType, C: ConsumerType where C.InputType == P.OutputType>(lhs: P, rhs: C) -> Producible  {
    
    return ProducerPipeline(head: lhs).finally(rhs)
}

public func |> <P: ProducerType>(lhs: P, rhs: P.OutputType -> Void) -> Producible  {
    
    return ProducerPipeline(head: lhs).finally(rhs)
}

public func |> <O, C: ConsumerType where C.InputType == O>(lhs: ProducerPipeline<O>, rhs: C) -> Producible  {
    
    return lhs.finally(rhs)
}

public func |> <O>(lhs: ProducerPipeline<O>, rhs: O -> Void) -> Producible  {
    
    return lhs.finally(rhs)
}

