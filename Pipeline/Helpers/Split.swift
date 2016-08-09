//
//  Split.swift
//  Pipeline
//
//  Created by Patrick Goley on 6/18/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public func split<C: ConsumerType>(consumers: C...) -> (C.InputType) -> C.InputType {
    
    return split(consumers)
}

public func split<C: ConsumerType>(consumers: [C]) -> (C.InputType) -> C.InputType {
    
    return { (input: C.InputType) in
        
        consumers.forEach { $0.consume(input) }
        
        return input
    }
}

public func split<I>(consumerFunctions: (I) -> Void...) -> (I) -> I {
    
    return split(consumerFunctions)
}

public func split<I>(consumerFunctions: [(I) -> Void]) -> (I) -> I {
    
    return { (input: I) in
        
        consumerFunctions.forEach { $0(input) }
        
        return input
    }
}
