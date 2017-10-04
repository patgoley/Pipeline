//
//  Operators.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/16/16.
//

import Foundation


precedencegroup CompositionPrecedence {
    higherThan: AssignmentPrecedence
    lowerThan: TernaryPrecedence
    associativity: left
}

infix operator |> : CompositionPrecedence
