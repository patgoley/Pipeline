//
//  NSBundlePipelines.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/16/16.
//

import Foundation
import Pipeline


public extension Bundle {
    
    func loadResource(_ name: String, fileExtension: String) -> ProducerPipeline<Data> {
        
        return { () -> URL? in return self.url(forResource: name, withExtension: fileExtension) }
            |> forceUnwrap
            |> FileManager.loadFromURL
            |> crashOnError
    }
}
