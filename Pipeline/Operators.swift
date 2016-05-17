//
//  Operators.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/16/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


infix operator |>   { precedence 50 associativity left }

public func |> <T: TransformerType, U: TransformerType where T.OutputType == U.InputType>(lhs: T, rhs: U) -> TransformerPipeline<T.InputType, U.OutputType>  {
    
    return TransformerPipeline(head: lhs).then(rhs)
}

public func |> <P: ProducerType, U: TransformerType where P.OutputType == U.InputType>(lhs: P, rhs: U) -> ProducerPipeline<U.OutputType>  {
    
    return ProducerPipeline(head: lhs).then(rhs)
}

public func |> <V, T: TransformerType where V == T.InputType>(lhs: V, rhs: T) -> ProducerPipeline<T.OutputType>  {
    
    let valueProducer = ValueProducer(value: lhs)
    
    return ProducerPipeline(head: valueProducer).then(rhs)
}

public func |> <V, T: TransformerType where V == T.InputType>(lhs: () -> V, rhs: T) -> ProducerPipeline<T.OutputType>  {
    
    let thunkProducer = ThunkProducer(thunk: lhs)
    
    return ProducerPipeline(head: thunkProducer).then(rhs)
}

public func |> <T: TransformerType, U>(lhs: T, rhs: T.OutputType -> U) -> TransformerPipeline<T.InputType, U>  {
    
    return TransformerPipeline(head: lhs).then(rhs)
}

public func |> <P: ProducerType, U>(lhs: P, rhs: P.OutputType -> U) -> ProducerPipeline<U>  {
    
    return ProducerPipeline(head: lhs).then(rhs)
}

public func |> <I, O, U where U: TransformerType, O == U.InputType>(lhs: TransformerPipeline<I, O>, rhs: U) -> TransformerPipeline<I, U.OutputType>  {
    
    return lhs.then(rhs)
}

public func |> <O, U where U: TransformerType, O == U.InputType>(lhs: ProducerPipeline<O>, rhs: U) -> ProducerPipeline<U.OutputType>  {
    
    return lhs.then(rhs)
}

public func |> <I, O, U>(lhs: TransformerPipeline<I, O>, rhs: O -> U) -> TransformerPipeline<I, U>  {
    
    return lhs.then(rhs)
}

public func |> <O, U>(lhs: ProducerPipeline<O>, rhs: O -> U) -> ProducerPipeline<U>  {
    
    return lhs.then(rhs)
}

public func |> <P: ProducerType, C: ConsumerType where C.InputType == P.OutputType>(lhs: P, rhs: C) -> P  {
    
    var producer = lhs
    
    return producer.finally(rhs)
}

public func |> <P: ProducerType>(lhs: P, rhs: P.OutputType -> Void) -> P  {
    
    var producer = lhs
    
    return producer.finally(rhs)
}


