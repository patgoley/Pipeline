//
//  ConsumableOperators.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/24/16.
//

import Foundation


// Creation

public func |> <S: ConsumableType, T: TransformerType where S.OutputType == T.InputType>(lhs: S, rhs: T) -> ConsumablePipeline<T.OutputType>  {
    
    return lhs.then(rhs)
}

public func |> <S: ConsumableType, NewOutput>(lhs: S, rhs: S.OutputType -> NewOutput) -> ConsumablePipeline<NewOutput>  {
    
    return lhs.then(rhs)
}


// Finally

public func |> <S: ConsumableType, C: ConsumerType where S.OutputType == C.InputType>(lhs: S, rhs: C) -> Pipeline  {
    
    return lhs.finally(rhs)
}

public func |> <C: ConsumableType>(lhs: C, rhs: C.OutputType -> Void) -> Pipeline  {
    
    return lhs.finally(rhs)
}


// Throwing

public func |> <S: ConsumableType, NewOutput>(lhs: S, rhs: S.OutputType throws -> NewOutput) -> ConsumablePipeline<Result<NewOutput>>  {
    
    let resultFunction = map(rhs)
    
    return lhs.then(resultFunction)
}