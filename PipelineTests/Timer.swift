//
//  Timer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation
import Pipeline

public final class Timer: ProducerType {
    
    public typealias OutputType = Date
    
    fileprivate var timer: Foundation.Timer? = nil
    
    public let interval: TimeInterval
    
    public let repeats: Bool
    
    public var consumer: ((Date) -> Void)?
    
    public var target: (() -> Void)?
    
    public init(interval: TimeInterval, repeats: Bool = true) {
        
        self.interval = interval
        
        self.repeats = repeats
    }
    
    public func start() {
        
        timer = Foundation.Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(tick), userInfo: nil, repeats: repeats)
    }
    
    public func stop() {
        
        timer?.invalidate()
        timer = nil
    }
    
    public func produce() {
        
        tick()
    }
    
    @objc func tick() {
        
        if let consumer = consumer {
            
            let date = Date()
            
            consumer(date)
        }
        
        if let target = target {
            
            target()
        }
    }
}


