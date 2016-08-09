//
//  ExecutionTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 6/17/16.
//  Copyright © 2016 pipeline. All rights reserved.
//

import XCTest
@testable import Pipeline

class ExecutionTests: XCTestCase {
    
    func testProduceWithCompletion() {
        
        let pipe = { return 123 } |> ThunkTransformer<Int, Int>() { x in
            
            return x + 5
        }
        
        let expt = expectationWithDescription("execution")
        
        pipe.produce() { x in
            
            XCTAssert(x == 128)
            
            expt.fulfill()
        }
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testConsumeWithCompletion() {
        
        let expt = expectationWithDescription("execution")
        
        let pipe = { (x: Int) in return x + 5 }
            |> { (x: Int) in return "\(x)" }
        
        pipe.consume(321) { (x: String) in
            
            XCTAssert(x == "326")
            
            expt.fulfill()
        }
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testPipelineProduceWithRetainsSelf() {
        
        let pipe = { return 123 }
            |> asyncBackgroundThread()
            |> delay(1)
            |> ensureMainThread()
            |> ThunkTransformer<Int, Int>() { x in
            
            return x + 5
        }
        
        pipe.produce() { x in
            
            XCTAssert(x == 128)
        }
    }
    
    func testPipelineConsumeRetainsSelf() {
        
        let pipe = { (x: Int) in return x + 5 }
            |> asyncBackgroundThread()
            |> delay(1)
            |> ensureMainThread()
            |> { (x: Int) in return "\(x)" }
        
        pipe.consume(321) { (x: String) in
            
            XCTAssert(x == "326")
        }
    }
}

final class TestConsumable {
    
    
}
