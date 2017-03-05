//
//  ConsumableOperators.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/24/16.
//

import Foundation


// Creation

public func |> <S: ConsumableType, T: TransformerType>(lhs: S, rhs: T) -> ConsumablePipeline<T.OutputType> where S.OutputType == T.InputType  {
    
    return lhs.then(rhs)
}

public func |> <S: ConsumableType, NewOutput>(lhs: S, rhs: @escaping (S.OutputType) -> NewOutput) -> ConsumablePipeline<NewOutput>  {
    
    return lhs.then(rhs)
}


// Finally

public func |> <S: ConsumableType, C: ConsumerType>(lhs: S, rhs: C) -> Pipeline where S.OutputType == C.InputType  {
    
    return lhs.finally(rhs)
}

public func |> <C: ConsumableType>(lhs: C, rhs: @escaping (C.OutputType) -> Void) -> Pipeline  {
    
    return lhs.finally(rhs)
}


// Throwing

public func |> <S: ConsumableType, NewOutput>(lhs: S, rhs: @escaping (S.OutputType) throws -> NewOutput) -> ConsumablePipeline<Result<NewOutput>>  {
    
    let resultFunction = map(rhs)
    
    return lhs.then(resultFunction)
}
