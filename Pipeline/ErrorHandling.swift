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

public func forceUnwrap<T>(input: T?) -> T {
    
    return input!
}

public func forceUnwrap<T, U>(transform: T -> U?) -> (T -> U) {
    
    return {
        
        transform($0)!
    }
}

public func downCast<T, U>(toType: U.Type) -> OptionalFilterTransformer<T, U> {
    
    return OptionalFilterTransformer() { $0 as? U }
}

public func forceCast<T, U>(toType: U.Type) -> AnyTransformer<T, U> {
    
    return AnyTransformer() { $0 as! U }
}

public func swallowError<T>(log log: Bool = true) -> OptionalFilterTransformer<Result<T>, T> {
    
    return OptionalFilterTransformer() {
    
        switch $0 {
            
        case .Success(let value):
            
            return value
            
        case .Error(let err):
            
            if log {
                
                print("Pipeline error: \(err)")
            }
            
            return nil
        }
    }
}

public func crashOnError<T>(result: Result<T>) -> T {
    
    switch result {
        
    case .Success(let value):
        
        return value
        
    case .Error(let err):
        
        fatalError("ERROR: \(err)")
    }
}

final class ThrowingTransformer<T, U>: TransformerType {
    
    typealias InputType = T
    
    typealias OutputType = Result<U>
    
    var consumer: (OutputType -> Void)?
    
    let _transform: (T) throws -> U
    
    init(transform: (T) throws -> U) {
        
        self._transform = transform
    }
    
    func consume(input: InputType) {
        
        guard let consumer = consumer else {
            
            return
        }
        
        do {
            
            let result = try _transform(input)
            
            consumer(.Success(result))
            
        } catch let err {
            
            consumer(.Error(err))
        }
    }
}














