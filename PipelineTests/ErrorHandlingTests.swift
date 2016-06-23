//
//  ErrorHandlingTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 6/23/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import XCTest
import Pipeline

class ErrorHandlingTests: XCTestCase {

    func testSwallowError() {
        
        let result: Result<String> = .Error(MockError())
        
        let pipe = ValueProducer(result)
            |> swallowError(log: "found error")
            |> { _ in XCTAssert(false) }
        
        pipe.produce()
    }
    
    func testSwallowErrorSuccess() {
        
        let result: Result<String> = .Success("abc")
        
        let expt = expectationWithDescription("error")
        
        let pipe = ValueProducer(result)
            |> swallowError(log: "found error")
            |> { (str: String) in
                
                XCTAssert(str == "abc")
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testLogError() {
        
        let result: Result<String> = .Error(MockError())
        
        let pipe = ValueProducer(result)
            |> logError("found error")
            |> { _ in XCTAssert(false) }
        
        pipe.produce()
    }
    
    func testLogErrorSuccess() {
        
        let result: Result<String> = .Success("abc")
        
        let expt = expectationWithDescription("error")
        
        let pipe = ValueProducer(result)
            |> logError("found error")
            |> { (str: String) in
                
                XCTAssert(str == "abc")
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testOnError() {
        
        let result: Result<String> = .Error(MockError())
        
        let expt = expectationWithDescription("error")
        
        let pipe = ValueProducer(result) |> onError() { err in
            
            XCTAssert(err is MockError)
            
            expt.fulfill()
            
            } |> { (str: String) in
                
                XCTFail()
        }
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testOnErrorSuccess() {
        
        let result: Result<String> = .Success("success")
        
        let expt = expectationWithDescription("error")
        
        let pipe = ValueProducer(result) |> onError() { err in
            
            XCTFail()
            
            } |> { (str: String) in
                
                XCTAssert(str == "success")
                
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testResolveError() {
        
        let result: Result<String> = .Error(MockError())
        
        let expt = expectationWithDescription("error")
        
        let pipe = ValueProducer(result)
            |> resolveError() { err in
                
                return "resolved"
                
            } |> { (str: String) in
                
                XCTAssert(str == "resolved")
                
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testResolveErrorSuccess() {
        
        let result: Result<String> = .Success("success")
        
        let expt = expectationWithDescription("error")
        
        let pipe = ValueProducer(result)
            |> resolveError() { err in
                
                XCTFail()
                
                return "error"
                
            } |> { (str: String) in
                
                XCTAssert(str == "success")
                
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testMapThrowToResult() {
        
        let expt = expectationWithDescription("error")
        
        let throwingFunc: () throws -> String = {
            
            throw MockError()
        }
        
        let pipe = map(throwingFunc)
            |> resolveError() { err in
                
                return "resolved"
                
            } |> { (str: String) in
                
                XCTAssert(str == "resolved")
                
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
    
    func testConsumablePipelineThrowingFunction() {
        
        let expt = expectationWithDescription("error")
        
        let throwingFunc: String throws -> String = { str in
            
            throw MockError()
        }
        
        let pipe = { return "abc" }
            |> { (str: String) in return str }
            |> throwingFunc
            |> resolveError() { (err: ErrorType) in
                
                return "resolved"
                
            } |> { (str: String) in
                
                XCTAssert(str == "resolved")
                
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
}
