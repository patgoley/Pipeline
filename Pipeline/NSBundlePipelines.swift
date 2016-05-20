//
//  NSBundlePipelines.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/16/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public extension NSBundle {
    
    func loadResource(name: String, fileExtension: String) -> ProducerPipeline<NSData> {
        
        return { self.URLForResource(name, withExtension: fileExtension) }
            |> forceUnwrap
            |> NSFileManager.loadFromURL
            |> crashOnError
    }
}