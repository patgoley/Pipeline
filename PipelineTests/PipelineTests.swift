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
        
        let pipeline = Pipeline(head: timer)
        
        pipeline.then(<#T##transformer: T##T#>)
        
        let logger = Logger()
        
        pipeline.finally(logger)
        
        timer.start()
        
        let _ = expectationWithDescription("timer")
        
        waitForExpectationsWithTimeout(1000, handler: nil)
    }
}
