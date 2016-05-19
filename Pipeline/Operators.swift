//
//  Operators.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/16/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


infix operator |>   { precedence 50 associativity left }

// MARK: - Consumable

public func |> <S: ConsumableType, T: TransformerType where S.OutputType == T.InputType>(lhs: S, rhs: T) -> ConsumablePipeline<T.OutputType>  {
    
    return ConsumablePipeline(head: lhs).then(rhs)
}

public func |> <S: ConsumableType, NewOutput>(lhs: S, rhs: S.OutputType -> NewOutput) -> ConsumablePipeline<NewOutput>  {
    
    return ConsumablePipeline(head: lhs).then(rhs)
}

// MARK: - ProducerPipeline

public func |> <P: ProducerType, U: TransformerType where P.OutputType == U.InputType>(lhs: P, rhs: U) -> ProducerPipeline<U.OutputType>  {
    
    return ProducerPipeline(head: lhs).then(rhs)
}

public func |> <P: ProducerType, U>(lhs: P, rhs: P.OutputType -> U) -> ProducerPipeline<U>  {
    
    return ProducerPipeline(head: lhs).then(rhs)
}

public func |> <O, C where C: TransformerType, O == C.InputType>(lhs: ProducerPipeline<O>, rhs: C) -> ProducerPipeline<C.OutputType>  {
    
    return lhs.then(rhs)
}

public func |> <V, T: TransformerType where V == T.InputType>(lhs: V, rhs: T) -> ProducerPipeline<T.OutputType>  {
    
    let valueProducer = ValueProducer(value: lhs)
    
    return ProducerPipeline(head: valueProducer).then(rhs)
}

public func |> <V, T: TransformerType where V == T.InputType>(lhs: () -> V, rhs: T) -> ProducerPipeline<T.OutputType>  {
    
    let thunkProducer = ThunkProducer(thunk: lhs)
    
    return ProducerPipeline(head: thunkProducer).then(rhs)
}

public func |> <O, C>(lhs: ProducerPipeline<O>, rhs: O -> C) -> ProducerPipeline<C>  {
    
    return lhs.then(rhs)
}

public func |> <O, C: ConsumerType where C.InputType == O>(lhs: ProducerPipeline<O>, rhs: C) -> ProducerPipeline<O>  {
    
    return lhs.finally(rhs)
}

public func |> <O>(lhs: ProducerPipeline<O>, rhs: O -> Void) -> ProducerPipeline<O>  {
    
    return lhs.finally(rhs)
}

// MARK: - TransformerPipeline

public func |> <T: TransformerType, U: TransformerType where T.OutputType == U.InputType>(lhs: T, rhs: U) -> TransformerPipeline<T.InputType, U.OutputType>  {
    
    return TransformerPipeline(head: lhs).then(rhs)
}

public func |> <T: TransformerType, U>(lhs: T, rhs: T.OutputType -> U) -> TransformerPipeline<T.InputType, U>  {
    
    return TransformerPipeline(head: lhs).then(rhs)
}

public func |> <I, O, U where U: TransformerType, O == U.InputType>(lhs: TransformerPipeline<I, O>, rhs: U) -> TransformerPipeline<I, U.OutputType>  {
    
    return lhs.then(rhs)
}

public func |> <I, O, C>(lhs: TransformerPipeline<I, O>, rhs: O -> C) -> TransformerPipeline<I, C>  {
    
    return lhs.then(rhs)
}

public func |> <I, O, C: ConsumerType where C.InputType == O>(lhs: TransformerPipeline<I, O>, rhs: C) -> TransformerPipeline<I, O>  {
    
    return lhs.finally(rhs)
}

