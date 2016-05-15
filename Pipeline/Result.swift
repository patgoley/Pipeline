//
//  Result.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public protocol ResultType {
    
    associatedtype ValueType
}

public enum Result<T>: ResultType {
    
    public typealias ValueType = T
    
    case Success(T), Error(ErrorType)
}