//
//  Join.swift
//  Pipeline
//
//  Created by Patrick Goley on 6/18/16.
//  Copyright © 2016 pipeline. All rights reserved.
//

import Foundation


public final class Join<T, U>: TransformerType {
    
    public typealias InputType = Void
    
    public typealias OutputType = (T?, U?)
    
    private var latestValues: (first: T?, second: U?) = (nil, nil)
    
    public var consumer: (OutputType -> Void)?
    
    public func consume(_: Void) {
        
        consumer?(latestValues)
    }
    
    public func consumeFirst(input: T) {
    
        latestValues.first = input
        
        consumer?(latestValues)
    }
    
    public func consumeSecond(input: U) {
        
        latestValues.second = input
        
        consumer?(latestValues)
    }
}

public final class ThreeJoin<T, U, V>: TransformerType {
    
    public typealias InputType = Void
    
    public typealias OutputType = (T?, U?, V?)
    
    private var latestValues: (first: T?, second: U?, third: V?) = (nil, nil, nil)
    
    public var consumer: (OutputType -> Void)?
    
    public func consume(_: Void) {
        
        consumer?(latestValues)
    }
    
    public func consumeFirst(input: T) {
        
        latestValues.first = input
        
        consumer?(latestValues)
    }
    
    public func consumeSecond(input: U) {
        
        latestValues.second = input
        
        consumer?(latestValues)
    }
    
    public func consumeThird(input: V) {
        
        latestValues.third = input
        
        consumer?(latestValues)
    }
}

public func join<C: TransformerType, S: TransformerType>(first: C, second: S) -> Join<C.OutputType, S.OutputType> {
    
    let join = Join<C.OutputType, S.OutputType>()
    
    let _ = first |> join.consumeFirst
    let _ = second |> join.consumeSecond
    
    return join
}

public func join<C: TransformerType, S: TransformerType, M: TransformerType>(first: C, second: S, third: M) -> ThreeJoin<C.OutputType, S.OutputType, M.OutputType> {
    
    let join = ThreeJoin<C.OutputType, S.OutputType, M.OutputType>()
    
    let _ = first |> join.consumeFirst
    let _ = second |> join.consumeSecond
    let _ = third |> join.consumeThird
    
    return join
}

