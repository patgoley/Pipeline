//
//  TransformerOperators.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/24/16.
//

import Foundation

// Creation

public func |> <T: TransformerType, U: TransformerType where T.OutputType == U.InputType>(lhs: T, rhs: U) -> TransformerPipeline<T.InputType, U.OutputType>  {
    
    return lhs.then(rhs)
}

public func |> <T: TransformerType, U>(lhs: T, rhs: T.OutputType -> U) -> TransformerPipeline<T.InputType, U>  {
    
    return lhs.then(rhs)
}

public func |> <T: TransformerType, S, U where T.InputType == U>(lhs: S -> U, rhs: T) -> TransformerPipeline<S, T.OutputType>  {
    
    return TransformerPipeline(head: lhs).then(rhs)
}

public func |> <S, U, V>(lhs: S -> U, rhs: U -> V) -> TransformerPipeline<S, V>  {
    
    return TransformerPipeline(head: lhs).then(rhs)
}

// Finally

public func |> <T: TransformerType>(lhs: T, rhs: T.OutputType -> Void) -> AnyConsumer<T.InputType>  {
    
    return lhs.finally(rhs)
}

public func |> <T: TransformerType, C: ConsumerType where C.InputType == T.OutputType>(lhs: T, rhs: C) -> AnyConsumer<T.InputType>  {
    
    return lhs.finally(rhs)
}

public func |> <I, O, C: ConsumerType where C.InputType == O>(lhs: I -> O, rhs: C) -> AnyConsumer<I>  {
    
    return TransformerPipeline(head: lhs).finally(rhs)
}

public func |> <I, O>(lhs: I -> O, rhs: O -> Void) -> AnyConsumer<I>  {
    
    return TransformerPipeline(head: lhs).finally(rhs)
}


// Throwing

public func |> <T: TransformerType, U>(lhs: T, rhs: T.OutputType throws -> U) -> TransformerPipeline<T.InputType, Result<U>>  {
    
    let resultFunction = map(rhs)
    
    return lhs.then(resultFunction)
}
