//
//  NSFileManagerTransformers.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/16/16.
//

import Foundation
import Pipeline

public enum FileError: ErrorType {
    
    case NotFound
}

public extension NSFileManager {
    
    static func loadFromURL(url: NSURL) -> Result<NSData> {
        
        if let data = NSData(contentsOfURL: url) {
            
            return .Success(data)
            
        } else {
            
            return .Error(FileError.NotFound)
        }
    }
}

