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
    
    if let pipeline = lhs as? ConsumablePipeline<S.OutputType> {
        
        return pipeline.then(rhs)
    }
    
    return ConsumablePipeline(head: lhs).then(rhs)
}

public func |> <S: ConsumableType, NewOutput>(lhs: S, rhs: S.OutputType -> NewOutput) -> ConsumablePipeline<NewOutput>  {
    
    if let pipeline = lhs as? ConsumablePipeline<S.OutputType> {
        
        return pipeline.then(rhs)
    }
    
    return ConsumablePipeline(head: lhs).then(rhs)
}

public func |> <O, C: ConsumerType where C.InputType == O>(lhs: ConsumablePipeline<O>, rhs: C) -> ConsumablePipeline<O>  {
    
    return lhs.finally(rhs)
}

public func |> <O>(lhs: ConsumablePipeline<O>, rhs: O -> Void) -> ConsumablePipeline<O>  {
    
    return lhs.finally(rhs)
}

// MARK: - ProducerPipeline

public func |> <P: ProducerType, U: TransformerType where P.OutputType == U.InputType>(lhs: P, rhs: U) -> ProducerPipeline<U.OutputType>  {
    
    if let pipeline = lhs as? ProducerPipeline<P.OutputType> {
        
        return pipeline.then(rhs)
    }
    
    return ProducerPipeline(head: lhs).then(rhs)
}

public func |> <P: ProducerType, U>(lhs: P, rhs: P.OutputType -> U) -> ProducerPipeline<U>  {
    
    if let pipeline = lhs as? ProducerPipeline<P.OutputType> {
        
        return pipeline.then(rhs)
    }
    
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
    
    if let pipeline = lhs as? TransformerPipeline<T.InputType, T.OutputType> {
        
        return pipeline.then(rhs)
    }
    
    return TransformerPipeline(head: lhs).then(rhs)
}

public func |> <T: TransformerType, U>(lhs: T, rhs: T.OutputType -> U) -> TransformerPipeline<T.InputType, U>  {
    
    if let pipeline = lhs as? TransformerPipeline<T.InputType, T.OutputType> {
        
        return pipeline.then(rhs)
    }
    
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

public func |> <I, O, C: ConsumerType where C.InputType == O>(lhs: TransformerPipeline<I, O>, rhs: C) -> TransformerPipeline<I, O>  {
    
    return lhs.finally(rhs)
}

public func |> <I, O>(lhs: TransformerPipeline<I, O>, rhs: O -> Void) -> TransformerPipeline<I, O>  {
    
    return lhs.finally(rhs)
}

