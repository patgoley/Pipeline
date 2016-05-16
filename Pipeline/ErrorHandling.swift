//
//  ErrorHandling.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

public final class NilGuard<T, U>: TransformerType {
    
    public typealias InputType = T
    
    public typealias OutputType = U
    
    private let map: InputType -> OutputType?
    
    public var consumer: (OutputType -> Void)?
    
    init(map: InputType -> OutputType?) {
        
        self.map = map
    }
    
    public func consume(input: InputType) {
        
        guard let consumer = self.consumer,
                  value = map(input) else {
            
            return
        }
        
        consumer(value)
    }
}

public final class Downcast<T, U>: TransformerType {
    
    public typealias InputType = T
    
    public typealias OutputType = U
    
    public var consumer: (OutputType -> Void)?
    
    init(_ outType: U.Type) {
        
        
    }
    
    public func consume(input: InputType) {
        
        guard let consumer = self.consumer,
                  value = input as? OutputType else {
                
                return
        }
        
        consumer(value)
    }
}

public final class HandleResult<T>: TransformerType {
    
    public typealias InputType = Result<T>
    
    public typealias OutputType = T
    
    public var consumer: (OutputType -> Void)?
    
    public func consume(result: InputType) {
        
        guard let consumer = self.consumer else {
            
            return
        }
        
        switch result {
            
        case .Success(let x):
            
            consumer(x)
            
        case .Error(let err):
            
            fatalError("\(err)")
        }
    }
}
