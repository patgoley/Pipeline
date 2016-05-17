//
//  NSFileManagerTransformers.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/16/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

public enum FileError: ErrorType {
    
    case NotFound
}

public extension NSFileManager {
    
    static func urlLoader() -> AnyTransformer<NSURL, Result<NSData>> {
        
        return AnyTransformer() { url in
            
            if let data = NSData(contentsOfURL: url) {
                
                return .Success(data)
                
            } else {
                
                return .Error(FileError.NotFound)
            }
        }
    }
    
    static func pathLoader() -> AnyTransformer<String, Result<NSData>> {
        
        return AnyTransformer() { path in
            
            let fileManager = NSFileManager()
            
            if let data = fileManager.contentsAtPath(path) {
                
                return .Success(data)
                
            } else {
                
                return .Error(FileError.NotFound)
            }
        }
    }
}