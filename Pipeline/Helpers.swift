//
//  Helpers.swift
//  Pipeline
//
//  Created by Patrick Goley on 6/9/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

/*
 Stops the flow of values down the pipeline if a condition is not met.
 That is, values that result in false from the condition will not be
 passed to the consumer.
*/

public func filter<T>(condition: (T) -> Bool) -> FilterTransformer<T> {
    
    return FilterTransformer(condition: condition)
}

/*
 Stops the flow of values down the pipeline if a condition is met.
 That is, values that result in true from the condition will not be
 passed to the consumer.
 */

public func unless<T>(condition: (T) -> Bool) -> FilterTransformer<T> {
    
    return FilterTransformer() { (value: T) in
        
        return !condition(value)
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

public func forceCast<T, U>(toType: U.Type) -> (T) -> U {
    
    return { value in
        
        return value as! U
    }
}

