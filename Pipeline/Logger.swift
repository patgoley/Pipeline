//
//  Logger.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


class Logger: ConsumerType {
    
    typealias InputType = Any
    
    func consume(input: Any) {
        
        print(input)
    }
}