//
//  TransformerOperators.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/24/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

public func |> <T: TransformerType, U: TransformerType where T.OutputType == U.InputType>(lhs: T, rhs: U) -> TransformerPipeline<T.InputType, U.OutputType>  {
    
    return TransformerPipeline(head: lhs).then(rhs)
}

public func |> <T: TransformerType, U>(lhs: T, rhs: T.OutputType -> U) -> TransformerPipeline<T.InputType, U>  {
    
    return TransformerPipeline(head: lhs).then(rhs)
}

public func |> <T: TransformerType, U>(lhs: T, rhs: T.OutputType throws -> U) -> TransformerPipeline<T.InputType, Result<U>>  {
    
    return TransformerPipeline(head: lhs).then(rhs)
}

public func |> <T: TransformerType, S, U where T.InputType == U>(lhs: S -> U, rhs: T) -> TransformerPipeline<S, T.OutputType>  {
    
    let transformer = AnyTransformer(transform: lhs)
    
    return TransformerPipeline(head: transformer).then(rhs)
}

public func |> <I, O, U where U: TransformerType, O == U.InputType>(lhs: TransformerPipeline<I, O>, rhs: U) -> TransformerPipeline<I, U.OutputType>  {
    
    return lhs.then(rhs)
}

public func |> <I, O, C>(lhs: TransformerPipeline<I, O>, rhs: O -> C) -> TransformerPipeline<I, C>  {
    
    return lhs.then(rhs)
}

public func |> <I, O, C: ConsumerType where C.InputType == O>(lhs: TransformerPipeline<I, O>, rhs: C) -> AnyConsumer<I>  {
    
    return lhs.finally(rhs)
}

public func |> <T: TransformerType>(lhs: T, rhs: T.OutputType -> Void) -> AnyConsumer<T.InputType>  {
    
    return TransformerPipeline(head: lhs).finally(rhs)
}

public func |> <I, O>(lhs: TransformerPipeline<I, O>, rhs: O -> Void) -> AnyConsumer<I>  {
    
    return lhs.finally(rhs)
}

public func |> <S, U, V>(lhs: S -> U, rhs: U -> V) -> TransformerPipeline<S, V>  {
    
    return TransformerPipeline(head: lhs).then(rhs)
}

public func |> <I, O>(lhs: I -> O, rhs: O -> Void) -> AnyConsumer<I>  {
    
    let pipeline = TransformerPipeline(head: lhs)
    
    return pipeline.finally(rhs)
}

public func |> <I, O, C: ConsumerType where C.InputType == O>(lhs: I -> O, rhs: C) -> AnyConsumer<I>  {
    
    let pipeline = TransformerPipeline(head: lhs)
    
    return pipeline.finally(rhs)
}

