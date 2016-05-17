//
//  NSBundlePipelines.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/16/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public extension NSBundle {
    
    func loadResourcePipeline(name: String, fileExtension: String) -> ProducerPipeline<NSData> {
        
        return { self.URLForResource(name, withExtension: fileExtension) }
            |> guardUnwrap()
            |> NSFileManager.urlLoader()
            |> swallowError()
    }
}