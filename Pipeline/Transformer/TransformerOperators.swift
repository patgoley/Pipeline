//
//  TransformerOperators.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/24/16.
//  Copyright © 2016 pipeline. All rights reserved.
//

import Foundation

// Creation

/*
 TransformerType, TransformerType
*/

public func |> <T: TransformerType, U: TransformerType where T.OutputType == U.InputType>(lhs: T, rhs: U) -> Pipeline<T.InputType, U.OutputType>  {
    
    return Pipeline(head: lhs).then(rhs)
}

/*
 TransformerType, transform function
*/

public func |> <T: TransformerType, U>(lhs: T, rhs: T.OutputType -> U) -> Pipeline<T.InputType, U>  {
    
    return Pipeline(head: lhs).then(rhs)
}

/*
 transform function, TransformerType
*/

public func |> <T: TransformerType, U, V where T.InputType == V>(lhs: U -> V, rhs: T) -> Pipeline<U, T.OutputType>  {
    
    return Pipeline(head: lhs).then(rhs)
}

/*
 transform function, transform function
*/

public func |> <S, U, V>(lhs: S -> U, rhs: U -> V) -> Pipeline<S, V>  {
    
    return Pipeline(head: lhs).then(rhs)
}


// Chaining

/* 
 Pipeline, TransformerType
*/

public func |> <I, O, T where T: TransformerType, O == T.InputType>(lhs: Pipeline<I, O>, rhs: T) -> Pipeline<I, T.OutputType>  {
    
    return lhs.then(rhs)
}

/*
 Pipeline, transform function
*/

public func |> <I, O, C>(lhs: Pipeline<I, O>, rhs: O -> C) -> Pipeline<I, C>  {
    
    return lhs.then(rhs)
}
