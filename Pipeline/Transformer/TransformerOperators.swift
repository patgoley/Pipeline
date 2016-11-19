//
//  TransformerOperators.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/24/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

// Creation

public func |> <T: TransformerType, U: TransformerType>(lhs: T, rhs: U) -> TransformerPipeline<T.InputType, U.OutputType> where T.OutputType == U.InputType  {
    
    return lhs.then(rhs)
}

public func |> <T: TransformerType, U>(lhs: T, rhs: @escaping (T.OutputType) -> U) -> TransformerPipeline<T.InputType, U>  {
    
    return lhs.then(rhs)
}

public func |> <T: TransformerType, S, U>(lhs: @escaping (S) -> U, rhs: T) -> TransformerPipeline<S, T.OutputType> where T.InputType == U  {
    
    return AnyTransformer(transform: lhs).then(rhs)
}

public func |> <S, U, V>(lhs: @escaping (S) -> U, rhs: @escaping (U) -> V) -> TransformerPipeline<S, V>  {
    
    return AnyTransformer(transform: lhs).then(rhs)
}

// Throwing

public func !> <T: TransformerType, U>(lhs: T, rhs: @escaping (T.OutputType) throws -> U) -> TransformerPipeline<T.InputType, Result<U>>  {
    
    let resultFunction = errorMap(rhs)
    
    return lhs.then(resultFunction)
}


// Finally

public func |> <T: TransformerType>(lhs: T, rhs: @escaping (T.OutputType) -> Void) -> AnyConsumer<T.InputType>  {
    
    return lhs.finally(rhs)
}

public func |> <T: TransformerType, C: ConsumerType>(lhs: T, rhs: C) -> AnyConsumer<T.InputType> where C.InputType == T.OutputType  {
    
    return lhs.finally(rhs)
}

public func |> <I, O, C: ConsumerType>(lhs: @escaping (I) -> O, rhs: C) -> AnyConsumer<I> where C.InputType == O  {
    
    return AnyTransformer(transform: lhs).finally(rhs)
}

public func |> <I, O>(lhs: @escaping (I) -> O, rhs: @escaping (O) -> Void) -> AnyConsumer<I>  {
    
    return AnyTransformer(transform: lhs).finally(rhs)
}
