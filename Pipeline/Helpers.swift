//
//  Helpers.swift
//  Pipeline
//
//  Created by Patrick Goley on 6/9/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

/*
 Stops the flow of values down the pipeline unless a condition is met
*/

public func filter<T>(condition: (T) -> Bool) -> FilterTransformer<T> {
    
    return FilterTransformer(condition: condition)
}

/*
 Maps a value to another value and passes it down the pipeline.
 While the transform could be used directly, this helps the compiler
 some and makes the code a bit more readable and expressive.
*/

public func map<T, U>(transform: (T) -> U) -> AnyTransformer<T, U> {
    
    return AnyTransformer(transform: transform)
}

/*
 Unwraps optional values and filters out any nil values
*/

public func guardUnwrap<T>() -> OptionalFilterTransformer<T?, T> {
    
    return OptionalFilterTransformer() { $0 }
}

/*
 Unwraps optional values and invokes a closure when a nil value is encountered
 */

public func onNil<T>(handler: () -> Void) -> OptionalFilterTransformer<T?, T> {
    
    return OptionalFilterTransformer() { (value: T?) in
        
        if let val = value {
            
            return val
            
        } else {
            
            handler()
            
            return nil
        }
    }
}

/*
 Unwraps optional values returned from a closure and filters out any nil values.
 Useful for unwrapping optional values produced through optional chaining. 
 
 Example:
 
 guardUnwrap() { person.employer?.name }
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
 Attemtps to cast incoming values to the given type, filtering out values
 that fail to cast.
*/

public func downCast<T, U>(toType: U.Type) -> OptionalFilterTransformer<T, U> {
    
    return OptionalFilterTransformer() { $0 as? U }
}

/*
 Attemtps to cast incoming values to the given type, crashing on values
 that fail to cast.
 */

public func forceCast<T, U>(toType: U.Type) -> AnyTransformer<T, U> {
    
    return AnyTransformer() { $0 as! U }
}