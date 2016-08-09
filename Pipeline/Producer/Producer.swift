//
//  Producer.swift
//  Pipeline
//
//  Created by Patrick Goley on 8/8/16.
//  Copyright © 2016 pipeline. All rights reserved.
//

import Foundation


public protocol ProducerType: class {
    
    associatedtype OutputType
    
    var consumer: (OutputType -> Void)? { get set }
}