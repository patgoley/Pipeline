//
//  Parseable.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//

import Foundation

public protocol Parseable {
    
    static func createWithValues(_ value: [String: AnyObject]) -> Self
}
