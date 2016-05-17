//
//  JSONTransformers.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

public enum JSONError: ErrorType, CustomStringConvertible {
    
    case CastError(AnyClass)
    
    public var description: String {
        
        switch self {
            
        case CastError(let expectedType):
            
            return "Failed to cast object to expected type \(expectedType)"
        }
    }
}


public extension NSJSONSerialization {
    
    public static func deserializer() -> AnyTransformer<NSData, Result<AnyObject>> {
        
        return AnyTransformer<NSData, Result<AnyObject>>() { data in
            
            do {
                
                let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                
                return .Success(jsonObject)
                
            } catch {
                
                return .Error(error)
            }
        }
    }
    
    public static func objectDeserializer() -> AnyTransformer<NSData, Result<[String: AnyObject]>> {
        
        return AnyTransformer<NSData, Result<[String: AnyObject]>>() { data in
            
            do {
                
                if let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
                    
                    return .Success(jsonObject)
                }
                
                return .Error(JSONError.CastError(NSDictionary))
                
            } catch {
                
                return .Error(error)
            }
        }
    }
    
    public static func serializer() -> AnyTransformer<Either<NSArray, NSDictionary>, Result<NSData>> {
        
        return AnyTransformer() { either in
            
            let object: AnyObject
            
            switch either {
                
            case .First(let array): object = array
            case .Second(let dictionary): object = dictionary
            }
            
            do {
                
                let data = try NSJSONSerialization.dataWithJSONObject(object, options: .PrettyPrinted)
                
                return .Success(data)
                
            } catch {
                
                return .Error(error)
            }
        }
    }
}

