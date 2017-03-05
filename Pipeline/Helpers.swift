//
//  Helpers.swift
//  Pipeline
//
//  Created by Patrick Goley on 6/9/16.
//

import Foundation

/*
 Stops the flow of values down the pipeline if a condition is not met.
 That is, values that result in false from the condition will not be
 passed to the consumer.
*/

public func filter<T>(_ condition: @escaping  (T) -> Bool) -> FilterTransformer<T> {
    
    return FilterTransformer(condition: condition)
}

/*
 Stops the flow of values down the pipeline if a condition is met.
 That is, values that result in true from the condition will not be
 passed to the consumer.
 */

public func unless<T>(_ condition: @escaping (T) -> Bool) -> FilterTransformer<T> {
    
    return FilterTransformer() { (value: T) in
        
        return !condition(value)
    }
}

/*
 Maps a value to another value and passes it down the pipeline. While 
 the transform function could be used directly, this makes the intent
 explicit, making the code more readable and expressive.
*/

public func map<T, U>(_ transform: @escaping (T) -> U) -> AnyTransformer<T, U> {
    
    return AnyTransformer(transform: transform)
}


/*
 Attemtps to cast incoming values to the given type, filtering out values
 that fail to cast.
*/

public func downCast<T, U>(_ toType: U.Type) -> OptionalFilterTransformer<T, U> {
    
    return OptionalFilterTransformer() { $0 as? U }
}

/*
 Attemtps to cast incoming values to the given type, crashing on values
 that fail to cast.
 */

public func forceCast<T, U>(_ toType: U.Type) -> AnyTransformer<T, U> {
    
    return AnyTransformer() { $0 as! U }
}

