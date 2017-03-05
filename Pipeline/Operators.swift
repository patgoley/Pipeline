//
//  Operators.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/16/16.
//

import Foundation

precedencegroup Composition {
    
    associativity: left
    
    higherThan: BitwiseShiftPrecedence
}

infix operator |> : Composition

