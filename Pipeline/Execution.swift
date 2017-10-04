//
//  Execution.swift
//  Pipeline
//
//  Created by Patrick Goley on 6/17/16.
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
