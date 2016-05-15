//
//  JSONTransformer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

public protocol JSONSerializable { }

extension Dictionary: JSONSerializable { }

extension Array: JSONSerializable { }

public extension NSJSONSerialization {
    
    static func deserializer() -> AnyTransformer<NSData, Result<AnyObject>> {
        
        return AnyTransformer() { data in
            
            do {
                
                let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                
                return .Success(jsonObject)
                
            } catch {
                
                return .Error(error)
            }
        }
    }
    
    static func serializer() -> AnyTransformer<JSONSerializable, Result<NSData>> {
        
        return AnyTransformer() { object in
            
            do {
                
                let data = try NSJSONSerialization.dataWithJSONObject(object as! AnyObject, options: .PrettyPrinted)
                
                return .Success(data)
                
            } catch {
                
                return .Error(error)
            }
        }
    }
}

