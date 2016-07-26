//
//  Execution.swift
//  Pipeline
//
//  Created by Patrick Goley on 6/17/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public extension ProducerType {
    
    func produce(consumer: (OutputType) -> Void) {
        
        if let originalConsumer = self.consumer {
            
            self.consumer = { value in
                
                originalConsumer(value)
                
                consumer(value)
                
                self.consumer = originalConsumer
            }
            
        } else {
            
            self.consumer = { value in
                
                consumer(value)
                
                self.consumer = nil
            }
        }
        
        self.consumer = consumer
        
        produce()
    }
}

public extension TransformerType {
    
    func consume(value: InputType, consumer: (OutputType) -> Void) {
        
        if let originalConsumer = self.consumer {
            
            self.consumer = { value in
                
                originalConsumer(value)
                
                consumer(value)
                
                self.consumer = originalConsumer
            }
            
        } else {
            
            self.consumer = { value in
                
                consumer(value)
                
                self.consumer = nil
            }
        }
        
        consume(value)
    }
}
