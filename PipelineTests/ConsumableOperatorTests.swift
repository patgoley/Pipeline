//
//  ConsumableOperatorTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/24/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import XCTest
import Pipeline

class ConsumableOperatorTests: XCTestCase {

    func testConsumeableTransformerType() {
        
        let producer = ThunkProducer() { return 123 }
        
        let pipe = producer |> ThunkTransformer<Int, Int>() { (x: Int) in
            
            return x + 5
        }
        
        pipe.consumer = {
            
            XCTAssert($0 == 128)
        }
        
        producer.produce()
    }
    
    func testConsumeableTransformerFunction() {
        
        let producer = ThunkProducer<Int>() { return 123 }
        
        let consumable = AnyTransformer<Void, Int>(base: producer)
        
        let pipe = consumable |> { (x: Int) -> Int in
            
            return x + 5
        }
        
        pipe.consumer = {
            
            XCTAssert($0 == 128)
        }
        
        producer.produce()
    }
    
    func testConsumeableOptionalMap() {
        
        let producer = ThunkProducer<Int?>() { return nil }
        
        let expt = expectationWithDescription("nil")
        
        let pipe = producer |> optionalMap({ (int: Int) -> Int in int + 5 })
        
        pipe.consumer = { (x: Int?) in
            
            XCTAssertNil(x)
            
            expt.fulfill()
        }
        
        producer.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testConsumeableOptionalMapWithValue() {
        
        let producer = ThunkProducer<Int?>() { return 123 }
        
        let expt = expectationWithDescription("value")
        
        let pipe = producer |> optionalMap({ (int: Int) -> Int in int + 5 })
        
        pipe.consumer = { (x: Int?) in
            
            if let val = x {
                
                XCTAssert(val == 128)
                
            } else {
                
                XCTFail()
            }
            
            expt.fulfill()
        }
        
        producer.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testConsumeableTransformerOptionalMap() {
        
        let producer = ThunkProducer<Int?>() { return nil }
        
        let expt = expectationWithDescription("nil")
        
        let pipe = producer |> optionalMap(ThunkTransformer<Int, Int>() { (int: Int) -> Int in int + 5 })
        
        pipe.consumer = { (x: Int?) in
            
            XCTAssertNil(x)
            
            expt.fulfill()
        }
        
        producer.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testConsumeableTransformerOptionalMapWithValue() {
        
        let producer = ThunkProducer<Int?>() { return 123 }
        
        let expt = expectationWithDescription("value")
        
        let pipe = producer |> optionalMap(ThunkTransformer<Int, Int>() { (int: Int) -> Int in int + 5 })
        
        pipe.consumer = { (x: Int?) in
            
            if let val = x {
                
                XCTAssert(val == 128)
                
            } else {
                
                XCTFail()
            }
            
            expt.fulfill()
        }
        
        producer.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
}
