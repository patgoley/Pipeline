//
//  Join.swift
//  Pipeline
//
//  Created by Patrick Goley on 6/18/16.
//

import Foundation


public final class Join<T, U>: ConsumableType {
    
    public typealias OutputType = (T?, U?)
    
    fileprivate var latestValues: (first: T?, second: U?) = (nil, nil)
    
    public var consumer: ((OutputType) -> Void)?
    
    public func consumeFirst(_ input: T) {
    
        latestValues.first = input
        
        consumer?(latestValues)
    }
    
    public func consumeSecond(_ input: U) {
        
        latestValues.second = input
        
        consumer?(latestValues)
    }
}

public final class ThreeJoin<T, U, V>: ConsumableType {
    
    public typealias OutputType = (T?, U?, V?)
    
    fileprivate var latestValues: (first: T?, second: U?, third: V?) = (nil, nil, nil)
    
    public var consumer: ((OutputType) -> Void)?
    
    public func consumeFirst(_ input: T) {
        
        latestValues.first = input
        
        consumer?(latestValues)
    }
    
    public func consumeSecond(_ input: U) {
        
        latestValues.second = input
        
        consumer?(latestValues)
    }
    
    public func consumeThird(_ input: V) {
        
        latestValues.third = input
        
        consumer?(latestValues)
    }
}

public func join<C: ConsumableType, S: ConsumableType>(_ first: C, second: S) -> Join<C.OutputType, S.OutputType> {
    
    let join = Join<C.OutputType, S.OutputType>()
    
    let _ = first |> join.consumeFirst
    let _ = second |> join.consumeSecond
    
    return join
}

public func join<C: ConsumableType, S: ConsumableType, M: ConsumableType>(_ first: C, second: S, third: M) -> ThreeJoin<C.OutputType, S.OutputType, M.OutputType> {
    
    let join = ThreeJoin<C.OutputType, S.OutputType, M.OutputType>()
    
    let _ = first |> join.consumeFirst
    let _ = second |> join.consumeSecond
    let _ = third |> join.consumeThird
    
    return join
}

