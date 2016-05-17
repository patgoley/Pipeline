//
//  PipelineTests.swift
//  PipelineTests
//
//  Created by Patrick Goley on 5/14/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import XCTest
@testable import Pipeline

class PipelineTests: XCTestCase {
    
    func testDateLogger() {
        
        let timer = Timer(interval: 1.0, repeats: true)
        
        var _ = ProducerPipeline(head: timer).then { $0.description }.finally(Logger())
        
        timer.start()
        
        let _ = expectationWithDescription("timer")
        
        waitForExpectationsWithTimeout(1000, handler: nil)
    }
}
