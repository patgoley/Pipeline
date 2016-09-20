//
//  NSFileManagerTransformers.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/16/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation
import Pipeline

public enum FileError: Error {
    
    case notFound
}

public extension FileManager {
    
    static func loadFromURL(_ url: URL) -> Result<Data> {
        
        if let data = try? Data(contentsOf: url) {
            
            return .success(data)
            
        } else {
            
            return .error(FileError.notFound)
        }
    }
    
    static func loadFromPath(_ path: String) -> Result<Data> {
        
        let fileManager = FileManager()
        
        if let data = fileManager.contents(atPath: path) {
            
            return .success(data)
            
        } else {
            
            return .error(FileError.notFound)
        }
    }
}

