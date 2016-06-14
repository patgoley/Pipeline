//
//  ErrorHandling.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

/*
 A type expressing the result of a process with potential error cases.
 The value is either the resulting value or an ErrorType created in attempting
 to produce the result.
*/

public enum Result<T> {
    
    public typealias ValueType = T
    
    case Success(T), Error(ErrorType)
}

/*
 Unwraps a Result<T> value or catches the error,
 optionally logs it, and halts execution of the Pipeline
*/

public func swallowError<T>(log logMessage: String? = nil) -> OptionalFilterTransformer<Result<T>, T> {
    
    return OptionalFilterTransformer() {
        
        switch $0 {
            
        case .Success(let value):
            
            return value
            
        case .Error(let err):
            
            if let message = logMessage {
                
                print("\n\(message)\nerror: \(err)")
            }
            
            return nil
        }
    }
}

/*
 Unwraps a Result<T> value or causes a fatalError
*/

public func crashOnError<T>(result: Result<T>) -> T {
    
    switch result {
        
    case .Success(let value):
        
        return value
        
    case .Error(let err):
        
        fatalError("ERROR: \(err)")
    }
}

/*
 A produces a transformer that encapsulates a throwing function. 
 Produces a Result<T> which is either the result of the function 
 or the ErrorType that was thrown.
*/

func map<T, U>(transform: (T) throws -> U) -> AnyTransformer<T, Result<U>> {
    
    return AnyTransformer() { input in
        
        do {
            
            let result = try transform(input)
            
            return .Success(result)
            
        } catch let err {
            
            return .Error(err)
        }
    }
}
