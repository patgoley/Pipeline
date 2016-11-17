//
//  Consumer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//

import Foundation


public protocol ConsumerType: class {
    
    associatedtype InputType
    
    func consume(_: InputType)
}