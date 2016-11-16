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
        
        let pipe = { () -> Int in return 123 } |> AnyTransformer<Int, Int>() { (x: Int) in
            
            return x + 5
        }
        
        pipe.consumer = { (x: Int) in
            
            XCTAssert(x == 128)
        }
        
        pipe.produce()
    }
    
    func testProducerConsumerType() {
        
        let anyProducer = AnyProducer<Int>(base: ValueProducer<Int>(123))
        
        let pipe = anyProducer |> AnyConsumer<Int>() { (x: Int) in
            
            XCTAssert(x == 123)
        }
        
        pipe.produce()
    }
    
    func testProducerPipelineTransformerType() {
        
        let anyProducer = AnyProducer<Int>(base: ValueProducer<Int>(123))
        
        let pipe = anyProducer
            |> integerIdentity
            |> AnyTransformer<Int, Int>() { (x: Int) -> Int in
            
                return x + 1
            
            } |> { (x: Int) in
                
                XCTAssert(x == 124)
            }
        
        pipe.produce()
    }
    
    func testProducerConsumerFunction() {
        
        let pipe = ValueProducer<Int>(123) |> { (x: Int) in
            
            XCTAssert(x == 123)
        }
        
        pipe.produce()
    }
    
    func testProducerPipelineConsumerType() {
        
        let pipe = ValueProducer<Int>(123)
            |> integerIdentity
            |> AnyConsumer<Int>() { (x: Int) in
            
            XCTAssert(x == 123)
        }
        
        pipe.produce()
    }
    
    func testProducerPipelineThrowingTransformerFunction() {
        
        let expt = expectation(description: "error")
        
        let pipe = ValueProducer<Int>(123)
            |> integerIdentity
            !> { (x: Int) throws -> Int in
                
                throw MockError()
                
        } |> { (result: Result<Int>) in
        
            switch result {
                
            case .success: XCTFail()
            default: break
            }
            
            expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testThrowingProducerFunction() {
        
        let expt = expectation(description: "error")
        
        let throwingFunc: () throws -> String = {
            
            throw MockError()
        }
        
        let pipe = throwingFunc
            !> resolveError() { () -> String in
                
                return "resolved"
                
            } |> { (str: String) in
                
                XCTAssert(str == "resolved")
                
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testProducerThrowingFunction() {
        
        let expt = expectation(description: "error")
        
        let throwingFunc: (String) throws -> String = { str in
            
            throw MockError()
        }
        
        let pipe = ThunkProducer<String>() { return "abc" }
            !> throwingFunc
            |> resolveError() { () -> String in
                
                return "resolved"
                
            } |> { (str: String) -> Void in
                
                XCTAssert(str == "resolved")
                
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testProducerPipelineThrowingFunction() {
        
        let expt = expectation(description: "error")
        
        let throwingFunc: (String) throws -> String = { str in
            
            throw MockError()
        }
        
        let pipe = { return "abc" }
            |> stringIdentity
            !> throwingFunc
            |> resolveError() {
                
                return "resolved"
                
            } |> { (str: String) in
                
                XCTAssert(str == "resolved")
                
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
