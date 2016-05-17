//
//  Result.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

public enum Result<T> {
    
    public typealias ValueType = T
    
    case Success(T), Error(ErrorType)
}

public enum Either<A, B> {
    
    case First(A), Second(B)
}

