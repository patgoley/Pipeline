//
//  ConsumableOperators.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/24/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

public func |> <S: ConsumableType, T: TransformerType where S.OutputType == T.InputType>(lhs: S, rhs: T) -> ConsumablePipeline<T.OutputType>  {
    
    return ConsumablePipeline(head: lhs).then(rhs)
}

public func |> <S: ConsumableType, NewOutput>(lhs: S, rhs: S.OutputType -> NewOutput) -> ConsumablePipeline<NewOutput>  {
    
    return ConsumablePipeline(head: lhs).then(rhs)
}

public func |> <S: ConsumableType, C: ConsumerType where S.OutputType == C.InputType>(lhs: S, rhs: C) -> Pipeline  {
    
    return ConsumablePipeline(head: lhs).finally(rhs)
}

public func |> <C: ConsumableType>(lhs: C, rhs: C.OutputType -> Void) -> Pipeline  {
    
    return ConsumablePipeline(head: lhs).finally(rhs)
}

public func |> <O, C: ConsumerType where C.InputType == O>(lhs: ConsumablePipeline<O>, rhs: C) -> Pipeline  {
    
    return lhs.finally(rhs)
}

public func |> <O>(lhs: ConsumablePipeline<O>, rhs: O -> Void) -> Pipeline  {
    
    return lhs.finally(rhs)
}