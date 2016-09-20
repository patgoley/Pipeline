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
        
        if Thread.isMainThread {
            
            consumer(input)
            
        } else {
            
            DispatchQueue.main.async {
                
                consumer(input)
            }
        }
    }
}

func asyncBackgroundThread<T>(_ priority: DispatchQoS.QoSClass = .default) -> AsyncTransformer<T, T> {
    
    return AsyncTransformer() { input, consumer in
        
        DispatchQueue.global(qos: priority).async {
            
            consumer(input)
        }
    }
}

func delay<T>(_ seconds: TimeInterval, queue: DispatchQueue = DispatchQueue.main) -> AsyncTransformer<T, T> {
    
    return AsyncTransformer() { input, consumer in
        
        _delay(seconds) {
            
            consumer(input)
        }
    }
}

private func _delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
