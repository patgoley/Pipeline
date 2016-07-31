//
//  TransformerOperators.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/24/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

// Creation

public func |> <T: TransformerType, U: TransformerType where T.OutputType == U.InputType>(lhs: T, rhs: U) -> Pipeline<T.InputType, U.OutputType>  {
    
    return Pipeline(head: lhs).then(rhs)
}

public func |> <T: TransformerType, U>(lhs: T, rhs: T.OutputType -> U) -> Pipeline<T.InputType, U>  {
    
    return Pipeline(head: lhs).then(rhs)
}

public func |> <T: TransformerType, S, U where T.InputType == U>(lhs: S -> U, rhs: T) -> Pipeline<S, T.OutputType>  {
    
    return Pipeline(head: lhs).then(rhs)
}

public func |> <S, U, V>(lhs: S -> U, rhs: U -> V) -> Pipeline<S, V>  {
    
    return Pipeline(head: lhs).then(rhs)
}

public func |> <T: TransformerType, U>(lhs: T, rhs: T.OutputType throws -> U) -> Pipeline<T.InputType, Result<U>>  {
    
    let resultFunction = map(rhs)
    
    return Pipeline(head: lhs).then(resultFunction)
}

// Chaining

public func |> <I, O, U where U: TransformerType, O == U.InputType>(lhs: Pipeline<I, O>, rhs: U) -> Pipeline<I, U.OutputType>  {
    
    return lhs.then(rhs)
}

public func |> <I, O, C>(lhs: Pipeline<I, O>, rhs: O -> C) -> Pipeline<I, C>  {
    
    return lhs.then(rhs)
}

public func |> <I, O, C>(lhs: Pipeline<I, O>, rhs: O throws -> C) -> Pipeline<I, Result<C>>  {
    
    let resultFunction = map(rhs)
    
    return lhs.then(resultFunction)
}

