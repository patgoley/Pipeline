//
//  SplitterTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 6/18/16.
//

import XCTest
import Pipeline

class SplitterTests: XCTestCase {
    
    func testSplitter() {
        
        var consumers = [AnyConsumer<Int>]()
        
        for i in 0...4 {
            
            let expt = expectation(description: "consumer \(i)")
            
            let consumer = AnyConsumer<Int>() { x in
                
                XCTAssert(x == 123)
                
                expt.fulfill()
            }
            
            consumers.append(consumer)
        }
        
        let pipe = ValueProducer(123) |> split(consumers)
        
        pipe.produce()
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testVariadicSplit() {
        
        let exptA = expectation(description: "consumer a")
        
        let consumerA = AnyConsumer<Int>() { x in
            
            XCTAssert(x == 123)
            
            exptA.fulfill()
        }
        
        let exptB = expectation(description: "consumer b")
        
        let consumerB = AnyConsumer<Int>() { x in
            
            XCTAssert(x == 123)
            
            exptB.fulfill()
        }
        
        let pipe = ValueProducer(123) |> split(consumerA, consumerB)
        
        pipe.produce()
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testFunctionSplit() {
        
        var consumers: [(Int) -> Void] = []
        
        for i in 0...4 {
            
            let expt = expectation(description: "consumer \(i)")
            
            let consumer = { (x: Int) in
                
                XCTAssert(x == 123)
                
                expt.fulfill()
            }
            
            consumers.append(consumer)
        }
        
        let pipe = ValueProducer(123) |> split(consumers)
        
        pipe.produce()
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testVariadicFunctionSplit() {
        
        let exptA = expectation(description: "consumer a")
        
        let consumerA = { (x: Int) in
            
            XCTAssert(x == 123)
            
            exptA.fulfill()
        }
        
        let exptB = expectation(description: "consumer b")
        
        let consumerB = { (x: Int) in
            
            XCTAssert(x == 123)
            
            exptB.fulfill()
        }
        
        let pipe = ValueProducer(123) |> split(consumerA, consumerB)
        
        pipe.produce()
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
