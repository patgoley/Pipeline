//
//  OptionalHelpers.swift
//  Pipeline
//
//  Created by Patrick Goley on 6/23/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


/*
 Unwraps optional values and filters out any nil values
 */

public func guardUnwrap<T>() -> OptionalFilterTransformer<T?, T> {
    
    return OptionalFilterTransformer() { $0 }
}

/*
 Unwraps optional values returned from a closure and filters out any nil values.
 Useful for unwrapping optional values produced through optional chaining.
 
 Example:
 
 guardUnwrap() { person in person.employer?.name }
 */

public func guardUnwrap<T, U>(transform: T -> U?) -> OptionalFilterTransformer<T, U> {
    
    return OptionalFilterTransformer() { transform($0) }
}

/*
 Force unwraps an optional value. Use at your own risk.
 */

public func forceUnwrap<T>(input: T?) -> T {
    
    return input!
}

/*
 Force unwraps an optional value produced from a closure. Use at your own risk.
 */

public func forceUnwrap<T, U>(transform: T -> U?) -> (T -> U) {
    
    return {
        
        transform($0)!
    }
}

/*
 Unwraps a Result<T> value or passes the error to a closure that
 should resolve the error and provide a value in place of the error
 that occurred.
 */

public func resolveNil<T>(resolve: () -> T) -> T? -> T {
    
    return { optional in
        
        if let value = optional {
            
            return value
            
        } else {
            
            return resolve()
        }
    }
}

public func resolveNil<T: TransformerType, V where T.InputType == Void, T.OutputType == V>(resolve: T) -> AsyncTransformer<V?, V> {
    
    return AsyncTransformer<V?, V>() { (input: V?, consumer: V -> Void) in
        
        if let value = input {
            
            consumer(value)
            
        } else {
            
            resolve.consumer = consumer
            
            resolve.produce()
        }
    }
}

/*
 Creates a function that attempts to unwrap and optional and apply a transform.
 Returns nil if nil is encountered. This mirrors the effect of optional
 chaining in dot notation. For example:
 
 `person.employer?.name` results in `String?`
 
 `() -> Employer? |> optionalMap(Employer -> String)` results in `() -> String?`
 
 */

public func optionalMap<T, U>(transform: T -> U) -> T? -> U? {
    
    return { input in
        
        if let value = input {
            
            return transform(value)
        }
        
        return nil
    }
}

public func optionalMap<T: TransformerType, U, V where T.InputType == U, T.OutputType == V>(transformer: T) -> AsyncTransformer<U?, V?> {
    
    return AsyncTransformer() { input, consumer in
        
        if let value = input {
            
            transformer.consumer = consumer
            
            transformer.consume(value)
            
        } else {
            
            consumer(nil)
        }
    }
}



