//
//  TimerTests.swift
//  PipelineTests
//
//  Created by Patrick Goley on 5/14/16.
//

import XCTest
@testable import Pipeline

class TimerTests: XCTestCase {
    
    func testDateLogger() {
        
        let timer = Timer(interval: 1.0, repeats: true)
        
        let timerExpectation = expectationWithDescription("timer")
        
        var count = 0
        
        let _ = timer
            |> logToConsole
            |> { _ in
            
            XCTAssertTrue(true)
            
            count += 1
            
            if count == 2 {
                
                timerExpectation.fulfill()
            }
        }
        
        timer.start()
        
        waitForExpectationsWithTimeout(3.0, handler: nil)
    }
}
