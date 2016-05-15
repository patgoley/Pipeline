//
//  ErrorHandling.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

struct NilGuard<T, U>: TransformerType {
    
    typealias InputType = T
    
    typealias OutputType = U
    
    private let map: InputType -> OutputType?
    
    var consumer: (OutputType -> Void)?
    
    init(map: InputType -> OutputType?) {
        
        self.map = map
    }
    
    func consume(input: InputType) {
        
        guard let consumer = self.consumer,
                  value = map(input) else {
            
            return
        }
        
        consumer(value)
    }
}

struct HandleResult<T>: TransformerType {
    
    typealias InputType = Result<T>
    
    typealias OutputType = T
    
    var consumer: (OutputType -> Void)?
    
    func consume(result: InputType) {
        
        guard let consumer = self.consumer else {
            
            return
        }
        
        switch result {
            
        case .Success(let x):
            
            consumer(x)
            
        case .Error(let err):
            
            fatalError("\(err)")
        }
    }
}
