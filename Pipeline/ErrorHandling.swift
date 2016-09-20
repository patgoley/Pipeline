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
    
    case success(T), error(Error)
}

/*
 Unwraps a Result<T> value or catches the error,
 optionally logs it, and halts execution of the Pipeline
*/

public func swallowError<T>(log logMessage: String? = nil) -> OptionalFilterTransformer<Result<T>, T> {
    
    return OptionalFilterTransformer() { result in
        
        switch result {
            
        case .success(let value):
            
            return value
            
        case .error(let err):
            
            if let message = logMessage {
                
                print("\n\(message)\nerror: \(err)")
            }
            
            return nil
        }
    }
}

/*
 Unwraps a Result<T> value or catches the error and
 logs it with a message
 */

public func logError<T>(_ message: String) -> OptionalFilterTransformer<Result<T>, T> {
    
    return onError() { err in
        
        print("\(message)\n\(err)")
    }
}

/*
 Unwraps a Result<T> value or pass the error to a closure
 */

public func onError<T>(_ handler: @escaping (Error) -> Void) -> OptionalFilterTransformer<Result<T>, T> {
    
    return OptionalFilterTransformer() { result in
        
        switch result {
            
        case .success(let value):
            
            return value
            
        case .error(let err):
            
            handler(err)
            
            return nil
        }
    }
}

/*
 Unwraps a Result<T> value or allows a closure to provide a value to fall 
 back on in case of errors.
 */

public func resolveError<T>(_ resolve: @escaping () -> T) -> (Result<T>) -> T {
    
    return { result in
        
        switch result {
            
        case .success(let value):
            
            return value
            
        case .error(_):
            
            return resolve()
        }
    }
}

/*
 Unwraps a Result<T> value or allows a ProducerType to provide a value
 to fall back on in case of errors.
 */

public func resolveError<P: ProducerType, V>(_ resolve: P) -> AsyncTransformer<Result<V>, V> where P.OutputType == V {
    
    return AsyncTransformer() { result, consumer in
        
        switch result {
            
        case .success(let value):
            
             consumer(value)
            
        case .error(_):
            
            resolve.consumer = consumer
            
            resolve.produce()
        }
    }
}

/*
 Unwraps a Result<T> value or causes a fatalError
*/

public func crashOnError<T>(_ result: Result<T>) -> T {
    
    switch result {
        
    case .success(let value):
        
        return value
        
    case .error(let err):
        
        fatalError("ERROR: \(err)")
    }
}

/*
 Produces a function that returns the result of a throwing function.
 Produces a Result<T> which is either the resulting value of the function
 or the ErrorType that was thrown.
*/

public func map<T, U>(_ transform: @escaping (T) throws -> U) -> (T) -> Result<U> {
    
    return { input in
        
        do {
            
            let result = try transform(input)
            
            return .success(result)
            
        } catch let err {
            
            return .error(err)
        }
    }
}

/*
 Produces a function that returns the result of a throwing function.
 Produces a Result<T> which is either the resulting value of the function
 or the ErrorType that was thrown.
 */

public func map<U>(_ produce: @escaping () throws -> U) -> () -> Result<U> {
    
    return { input in
        
        do {
            
            let result = try produce()
            
            return .success(result)
            
        } catch let err {
            
            return .error(err)
        }
    }
}
