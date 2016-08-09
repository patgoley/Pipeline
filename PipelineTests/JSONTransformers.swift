//
//  JSONTransformers.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 pipeline. All rights reserved.
//

import Foundation
import Pipeline

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
    
    public static func deserializeArray(data: NSData) -> Result<[AnyObject]> {
        
        do {
            
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            
            if let array = json as? [AnyObject] {
                
                return .Success(array)
                
            } else {
                
                return .Error(JSONError.CastError(NSArray))
            }
            
        } catch {
            
            return .Error(error)
        }
    }
    
    
    public static func deserializeObject(data: NSData) -> Result<[String: AnyObject]> {
        
        do {
            
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            
            if let object = json as? [String: AnyObject] {
                
                return .Success(object)
                
            } else {
                
                return .Error(JSONError.CastError(NSDictionary))
            }
            
        } catch {
            
            return .Error(error)
        }
    }
    
    public static func serializer(array: NSArray) -> Result<NSData> {
        
        do {
            
            let data = try NSJSONSerialization.dataWithJSONObject(array, options: .PrettyPrinted)
            
            return .Success(data)
            
        } catch {
            
            return .Error(error)
        }
    }
    
    public static func serializer(dict: NSDictionary) -> Result<NSData> {
        
        do {
            
            let data = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            
            return .Success(data)
            
        } catch {
            
            return .Error(error)
        }
    }
}




