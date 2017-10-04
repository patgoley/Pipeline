//
//  Timer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
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
        
        let date = Date()
        
        consumer?(date)
        
        target?()
    }
}


