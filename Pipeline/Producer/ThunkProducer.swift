//
//  ThunkProducer.swift
//  Pipeline
//
//  Created by Patrick Goley on 8/1/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public final class ThunkProducer<T>: TransformerType {
    
    public typealias InputType = Void
    
    let thunk: () -> T
    
    public var consumer: (T -> Void)?
    
    public init(thunk: () -> T) {
        
        self.thunk = thunk
    }
    
    public func consume(_: Void) {
        
        let value = thunk()
        
        consumer?(value)
    }
}