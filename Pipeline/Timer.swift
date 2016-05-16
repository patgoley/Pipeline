//
//  Timer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation


public final class Timer: ProducerType {
    
    public typealias OutputType = NSDate
    
    private var timer: NSTimer? = nil
    
    public let interval: NSTimeInterval
    
    public let repeats: Bool
    
    public var consumer: (NSDate -> Void)?
    
    public init(interval: NSTimeInterval, repeats: Bool) {
        
        self.interval = interval
        
        self.repeats = repeats
    }
    
    public func start() {
        
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(tick), userInfo: nil, repeats: repeats)
    }
    
    @objc func tick() {
        
        if let consumer = consumer {
            
            let date = NSDate()
            
            consumer(date)
        }
    }
}