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
        
        let timerExpectation = expectationWithDescription("timer")
        
        var _ = ProducerPipeline(head: timer).then { $0.description }.finally { _ in
            
            XCTAssertTrue(true)
            
            timerExpectation.fulfill()
        }
        
        timer.start()
        
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }
}
