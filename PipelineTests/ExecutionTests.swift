//
//  ExecutionTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 6/17/16.
//

import XCTest
@testable import Pipeline

class ExecutionTests: XCTestCase {
    
    func testProduceWithCompletion() {
        
        let pipe: ProducerPipeline<Int> = { return 123 } |> AnyTransformer<Int, Int>() { x in
            
            return x + 5
        }
        
        let expt = expectation(description: "execution")
        
        pipe.produce() { x in
            
            XCTAssert(x == 128)
            
            expt.fulfill()
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testConsumeWithCompletion() {
        
        let expt = expectation(description: "execution")
        
        let pipe = { (x: Int) in return x + 5 }
            |> { (x: Int) in return "\(x)" }
        
        pipe.consume(321) { (x: String) in
            
            XCTAssert(x == "326")
            
            expt.fulfill()
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testPipelineProduceWithRetainsSelf() {
        
        let pipe: ProducerPipeline<Int> = { return 123 }
            |> asyncBackgroundThread()
            |> delay(1)
            |> ensureMainThread()
            |> AnyTransformer<Int, Int>() { x in
            
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
