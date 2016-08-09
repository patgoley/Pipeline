//
//  Execution.swift
//  Pipeline
//
//  Created by Patrick Goley on 6/17/16.
//  Copyright © 2016 pipeline. All rights reserved.
//

import Foundation


public extension TransformerType {
    
    func consume(value: InputType, consumer: (OutputType) -> Void) {
        
        let originalConsumer = self.consumer
            
        self.consumer = { value in
            
            originalConsumer?(value)
            
            consumer(value)
            
            self.consumer = originalConsumer
        }
        
        consume(value)
    }
}

public extension TransformerType where InputType == Void {
    
    func produce(consumer: ((OutputType) -> Void)? = nil) {
        
        let originalConsumer = self.consumer
        
        self.consumer = { value in
            
            originalConsumer?(value)
            
            consumer?(value)
            
            self.consumer = originalConsumer
        }
        
        consume()
    }
}