//
//  Execution.swift
//  Pipeline
//
//  Created by Patrick Goley on 6/17/16.
//

import Foundation


public extension ProducerType {
    
    func produce(consumer: (OutputType) -> Void) {
        
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
