//
//  Timer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//

import Foundation
import Pipeline

public final class Timer: ProducerType {
    
    public typealias OutputType = NSDate
    
    private var timer: NSTimer? = nil
    
    public let interval: NSTimeInterval
    
    public let repeats: Bool
    
    public var consumer: (NSDate -> Void)?
    
    public var target: (() -> Void)?
    
    public init(interval: NSTimeInterval, repeats: Bool = true) {
        
        self.interval = interval
        
        self.repeats = repeats
    }
    
    public func start() {
        
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(tick), userInfo: nil, repeats: repeats)
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
            
            let date = NSDate()
            
            consumer(date)
        }
        
        if let target = target {
            
            target()
        }
    }
}


