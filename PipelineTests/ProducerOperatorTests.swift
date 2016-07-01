//
//  ProcuderOperatorTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/24/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import XCTest
import Pipeline

class ProducerOperatorTests: XCTestCase {
    
    func testProducerTransformerType() {
        
        let pipe = { return 123 } |> AnyTransformer() { x in
            
            return x + 5
        }
        
        pipe.consumer = { x in
            
            XCTAssert(x == 128)
        }
        
        pipe.produce()
    }
    
    func testProducerConsumerType() {
        
        let anyProducer = AnyProducer(base: ValueProducer(123))
        
        let pipe = anyProducer |> AnyConsumer() { x in
            
            XCTAssert(x == 123)
        }
        
        pipe.produce()
    }
    
    func testProducerPipelineTransformerType() {
        
        let anyProducer = AnyProducer(base: ValueProducer(123))
        
        let pipe = anyProducer
            |> integerIdentity
            |> AnyTransformer() { (x: Int) -> Int in
            
                return x + 1
            
            } |> { (x: Int) in
                
                XCTAssert(x == 124)
            }
        
        pipe.produce()
    }
    
    func testProducerConsumerFunction() {
        
        let pipe = ValueProducer(123) |> { (x: Int) in
            
            XCTAssert(x == 123)
        }
        
        pipe.produce()
    }
    
    func testProducerPipelineConsumerType() {
        
        let pipe = ValueProducer(123)
            |> integerIdentity
            |> AnyConsumer() { x in
            
            XCTAssert(x == 123)
        }
        
        pipe.produce()
    }
    
    func testProducerPipelineThrowingTransformerFunction() {
        
        let expt = expectationWithDescription("error")
        
        let pipe = ValueProducer(123)
            |> integerIdentity
            |> { (x: Int) throws -> Int in
                
                throw MockError()
                
        } |> { (result: Result<Int>) in
        
            switch result {
                
            case .Success: XCTFail()
            default: break
            }
            
            expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testThrowingProducerFunction() {
        
        let expt = expectationWithDescription("error")
        
        let throwingFunc: () throws -> String = {
            
            throw MockError()
        }
        
        let pipe = throwingFunc
            |> resolveError() { err in
                
                return "resolved"
                
            } |> { (str: String) in
                
                XCTAssert(str == "resolved")
                
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testProducerThrowingFunction() {
        
        let expt = expectationWithDescription("error")
        
        let throwingFunc: String throws -> String = { str in
            
            throw MockError()
        }
        
        let pipe = ThunkProducer() { return "abc" }
            |> throwingFunc
            |> resolveError() { () -> String in
                
                return "resolved"
                
            } |> { (str: String) -> Void in
                
                XCTAssert(str == "resolved")
                
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testProducerPipelineThrowingFunction() {
        
        let expt = expectationWithDescription("error")
        
        let throwingFunc: String throws -> String = { str in
            
            throw MockError()
        }
        
        let pipe = { return "abc" }
            |> stringIdentity
            |> throwingFunc
            |> resolveError() {
                
                return "resolved"
                
            } |> { (str: String) in
                
                XCTAssert(str == "resolved")
                
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
}
