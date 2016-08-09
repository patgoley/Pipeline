//
//  SplitterTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 6/18/16.
//  Copyright © 2016 pipeline. All rights reserved.
//

import XCTest
import Pipeline

class SplitterTests: XCTestCase {
    
    func testSplitter() {
        
        var consumers = [AnyConsumer<Int>]()
        
        for i in 0...4 {
            
            let expt = expectationWithDescription("consumer \(i)")
            
            let consumer = AnyConsumer<Int>() { x in
                
                XCTAssert(x == 123)
                
                expt.fulfill()
            }
            
            consumers.append(consumer)
        }
        
        let pipe = ValueProducer(123) |> split(consumers)
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }

    func testVariadicSplit() {
        
        let exptA = expectationWithDescription("consumer a")
        
        let consumerA = AnyConsumer<Int>() { x in
            
            XCTAssert(x == 123)
            
            exptA.fulfill()
        }
        
        let exptB = expectationWithDescription("consumer b")
        
        let consumerB = AnyConsumer<Int>() { x in
            
            XCTAssert(x == 123)
            
            exptB.fulfill()
        }
        
        let pipe = ValueProducer(123) |> split(consumerA, consumerB)
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testFunctionSplit() {
        
        var consumers: [(Int) -> Void] = []
        
        for i in 0...4 {
            
            let expt = expectationWithDescription("consumer \(i)")
            
            let consumer = { (x: Int) in
                
                XCTAssert(x == 123)
                
                expt.fulfill()
            }
            
            consumers.append(consumer)
        }
        
        let pipe = ValueProducer(123) |> split(consumers)
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testVariadicFunctionSplit() {
        
        let exptA = expectationWithDescription("consumer a")
        
        let consumerA = ThunkTransformer() { (x: Int) -> Int in
            
            XCTAssert(x == 123)
            
            exptA.fulfill()
            
            return x
        }
        
        let exptB = expectationWithDescription("consumer b")
        
        let consumerB = ThunkTransformer() { (x: Int) -> String in
            
            XCTAssert(x == 123)
            
            exptB.fulfill()
            
            return "\(x)"
        }
        
        let consumers: [AnyConsumer<Int>] = [AnyConsumer(base: consumerA), AnyConsumer(base: consumerB)]
        
        let pipe = ValueProducer(123) |> split(consumers)
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
}
