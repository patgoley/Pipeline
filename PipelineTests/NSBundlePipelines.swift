//
//  NSBundlePipelines.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/16/16.
//  Copyright © 2016 pipeline. All rights reserved.
//

import Foundation
import Pipeline


public extension NSBundle {
    
    func loadResource(name: String, fileExtension: String) -> Pipeline<Void, NSData> {
        
        return { () -> NSURL? in return self.URLForResource(name, withExtension: fileExtension) }
            |> forceUnwrap
            |> NSFileManager.loadFromURL
            |> crashOnError
    }
}