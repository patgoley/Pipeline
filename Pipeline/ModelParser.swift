//
//  ModelParser.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

public protocol Parseable {
    
    static func createWithValues(value: [String: AnyObject]) -> Self
}

public struct ModelParser<T: Parseable> {
    
    public static func JSONParser() -> TransformerPipeline<NSData, T> {
        
        return NSJSONSerialization.objectDeserializer
            |> swallowError()
            |> T.createWithValues
    }
    
    public static func parserFor(type: T.Type) -> AnyTransformer<[String: AnyObject], T> {
        
        return AnyTransformer { values in
            
            return T.createWithValues(values)
        }
    }
}