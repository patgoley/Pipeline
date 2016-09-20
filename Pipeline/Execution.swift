//
//  Execution.swift
//  Pipeline
//
//  Created by Patrick Goley on 6/17/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public extension ProducerType {
    
    func produce(_ consumer: @escaping (OutputType) -> Void) {
        
        let originalConsumer = self.consumer
            
        self.consumer = { value in
            
            originalConsumer?(value)
            
            consumer(value)
            
            self.consumer = originalConsumer
        }
        
        self.consumer = consumer
        
        produce()
    }
}

public extension TransformerType {
    
    func consume(_ value: InputType, consumer: @escaping (OutputType) -> Void) {
        
        let originalConsumer = self.consumer
            
        self.consumer = { value in
            
            originalConsumer?(value)
            
            consumer(value)
            
            self.consumer = originalConsumer
        }
        
        consume(value)
    }
}
