//
//  Logger.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


func logger<T: CustomStringConvertible>() -> PassThroughTransformer<T> {
    
    return PassThroughTransformer<T>() {
        
        print($0)
    }
}

func logToConsole<T>(input: T) -> T {
    
    print(input)
    
    return input
}