//
//  JSONTransformers.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//

import Foundation
import Pipeline

public enum JSONError: Error, CustomStringConvertible {
    
    case castError(AnyClass)
    
    public var description: String {
        
        switch self {
            
        case .castError(let expectedType):
            
            return "Failed to cast object to expected type \(expectedType)"
        }
    }
}


public extension JSONSerialization {
    
    public static func deserializeArray(_ data: Data) -> Result<[AnyObject]> {
        
        do {
            
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            if let array = json as? [AnyObject] {
                
                return .success(array)
                
            } else {
                
                return .error(JSONError.castError(NSArray))
            }
            
        } catch {
            
            return .error(error)
        }
    }
    
    
    public static func deserializeObject(_ data: Data) -> Result<[String: AnyObject]> {
        
        do {
            
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            if let object = json as? [String: AnyObject] {
                
                return .success(object)
                
            } else {
                
                return .error(JSONError.castError(NSDictionary))
            }
            
        } catch {
            
            return .error(error)
        }
    }
    
    public static func serializer(_ array: NSArray) -> Result<Data> {
        
        do {
            
            let data = try JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
            
            return .success(data)
            
        } catch {
            
            return .error(error)
        }
    }
    
    public static func serializer(_ dict: NSDictionary) -> Result<Data> {
        
        do {
            
            let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            
            return .success(data)
            
        } catch {
            
            return .error(error)
        }
    }
}




