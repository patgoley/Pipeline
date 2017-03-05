//
//  Logger.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//

import Foundation
import Pipeline


func logToConsole<T>(_ input: T) -> T {
    
    print(input)
    
    return input
}
