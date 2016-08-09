//
//  Consumer.swift
//  Pipeline
//
//  Created by Patrick Goley on 8/8/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public protocol ConsumerType: class {
    
    associatedtype InputType
    
    func consume(input: InputType)
}