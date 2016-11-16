//
//  ConsumableOperators.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/24/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

// Chaining

public func |> <S: ConsumableType, T: TransformerType>(lhs: S, rhs: T) -> ConsumablePipeline<T.OutputType> where S.OutputType == T.InputType  {
    
    return lhs.then(rhs)
}

public func |> <S: ConsumableType, NewOutput>(lhs: S, rhs: @escaping (S.OutputType) -> NewOutput) -> ConsumablePipeline<NewOutput>  {
    
    return lhs.then(rhs)
}

// Throwing

public func !> <S: ConsumableType, NewOutput>(lhs: S, rhs: @escaping (S.OutputType) throws -> NewOutput) -> ConsumablePipeline<Result<NewOutput>>  {
    
    let resultFunction = errorMap(rhs)
    
    return lhs.then(resultFunction)
}


// finally

public func |> <S: ConsumableType, C: ConsumerType>(lhs: S, rhs: C) -> Pipeline where S.OutputType == C.InputType  {
    
    return ConsumablePipeline(head: lhs).finally(rhs)
}

public func |> <C: ConsumableType>(lhs: C, rhs: @escaping (C.OutputType) -> Void) -> Pipeline  {
    
    return ConsumablePipeline(head: lhs).finally(rhs)
}

public func |> <O, C: ConsumerType>(lhs: ConsumablePipeline<O>, rhs: C) -> Pipeline where C.InputType == O  {
    
    return lhs.finally(rhs)
}

public func |> <O>(lhs: ConsumablePipeline<O>, rhs: @escaping (O) -> Void) -> Pipeline  {
    
    return lhs.finally(rhs)
}

