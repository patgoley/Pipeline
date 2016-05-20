//
//  Threading.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/20/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation
import Pipeline

func ensureMainThread<T>() -> AsyncTransformer<T, T> {
    
    return AsyncTransformer() { input, consumer in
        
        if NSThread.isMainThread() {
            
            consumer(input)
            
        } else {
            
            dispatch_async(dispatch_get_main_queue()) {
                
                consumer(input)
            }
        }
    }
}

func asyncBackgroundThread<T>(priority: dispatch_queue_priority_t = DISPATCH_QUEUE_PRIORITY_DEFAULT) -> AsyncTransformer<T, T> {
    
    return AsyncTransformer() { input, consumer in
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            consumer(input)
        }
    }
}