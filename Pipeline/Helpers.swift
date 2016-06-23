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
 Maps a value to another value and passes it down the pipeline. While 
 the transform function could be used directly, this makes the intent
 explicit, making the code more readable and expressive.
*/

public func map<T, U>(transform: (T) -> U) -> AnyTransformer<T, U> {
    
    return AnyTransformer(transform: transform)
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

