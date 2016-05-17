//
//  ErrorHandling.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

public func guardUnwrap<T>() -> OptionalFilterTransformer<T?, T> {
    
    return OptionalFilterTransformer() { $0 }
}

public func guardUnwrap<T, U>(transform: T -> U?) -> OptionalFilterTransformer<T, U> {
    
    return OptionalFilterTransformer() { transform($0) }
}

public func forceUnwrap<T>() -> AnyTransformer<T?, T> {
    
    return AnyTransformer() { $0! }
}

public func forceUnwrap<T, U>(transform: T -> U?) -> AnyTransformer<T, U> {
    
    return AnyTransformer() { transform($0)! }
}

public func downCast<T, U>(toType: U.Type) -> OptionalFilterTransformer<T, U> {
    
    return OptionalFilterTransformer() { $0 as? U }
}

public func forceCast<T, U>(toType: U.Type) -> AnyTransformer<T, U> {
    
    return AnyTransformer() { $0 as! U }
}

public func swallowError<T>() -> OptionalFilterTransformer<Result<T>, T> {
    
    return OptionalFilterTransformer() {
    
        switch $0 {
            
        case .Success(let value):
            
            return value
            
        case .Error( _):
            
            return nil
        }
    }
}

public func crashOnError<T>(result: Result<T>) -> AnyTransformer<Result<T>, T> {
    
    return AnyTransformer() {
        
        switch $0 {
            
        case .Success(let value):
            
            return value
            
        case .Error(let err):
            
            fatalError("ERROR: \(err)")
        }
    }
}




