//
//  Logger.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


struct Logger: ConsumerType {
    
    typealias InputType = String
    
    func consume(input: String) {
        
        print(input)
    }
}