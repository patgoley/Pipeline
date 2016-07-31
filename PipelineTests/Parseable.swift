//
//  Parseable.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

public protocol Parseable {
    
    static func createWithValues(value: [String: AnyObject]) -> Self
}