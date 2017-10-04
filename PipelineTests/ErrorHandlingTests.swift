//
//  ErrorHandlingTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 6/23/16.
//

import XCTest
import Pipeline

class ErrorHandlingTests: XCTestCase {

    func testSwallowError() {
        
        let result: Result<String> = .error(MockError())
        
        let pipe = ValueProducer(result)
            |> swallowError(log: "found error")
            |> { _ in XCTAssert(false) }
        
        pipe.produce()
    }
    
    func testSwallowErrorSuccess() {
        
        let result: Result<String> = .success("abc")
        
        let expt = expectation(description: "error")
        
        let pipe = ValueProducer(result)
            |> swallowError(log: "found error")
            |> { (str: String) in
                
                XCTAssert(str == "abc")
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testLogError() {
        
        let result: Result<String> = .error(MockError())
        
        let pipe = ValueProducer(result)
            |> logError("found error")
            |> { _ in XCTAssert(false) }
        
        pipe.produce()
    }
    
    func testLogErrorSuccess() {
        
        let result: Result<String> = .success("abc")
        
        let expt = expectation(description: "error")
        
        let pipe = ValueProducer(result)
            |> logError("found error")
            |> { (str: String) in
                
                XCTAssert(str == "abc")
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testOnError() {
        
        let result: Result<String> = .error(MockError())
        
        let expt = expectation(description: "error")
        
        let pipe = ValueProducer(result) |> onError() { err in
            
            XCTAssert(err is MockError)
            
            expt.fulfill()
            
            } |> { (str: String) in
                
                XCTFail()
        }
        
        pipe.produce()
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testOnErrorSuccess() {
        
        let result: Result<String> = .success("success")
        
        let expt = expectation(description: "error")
        
        let pipe = ValueProducer(result) |> onError() { err in
            
            XCTFail()
            
            } |> { (str: String) in
                
                XCTAssert(str == "success")
                
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testResolveError() {
        
        let result: Result<String> = .error(MockError())
        
        let expt = expectation(description: "error")
        
        let pipe = ValueProducer(result)
            |> resolveError() {
                
                return "resolved"
                
            } |> { (str: String) in
                
                XCTAssert(str == "resolved")
                
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testResolveErrorSuccess() {
        
        let result: Result<String> = .success("success")
        
        let expt = expectation(description: "error")
        
        let pipe = ValueProducer(result)
            |> resolveError() {
                
                XCTFail()
                
                return "error"
                
            } |> { (str: String) in
                    
                    XCTAssert(str == "success")
                    
                    expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testResolveErrorProducer() {
        
        let result: Result<String> = .error(MockError())
        
        let expt = expectation(description: "error")
        
        let pipe = ValueProducer(result)
            |> resolveError(ThunkProducer<String>() {
                
                return "resolved"
                
            }) |> { (str: String) in
                
                XCTAssert(str == "resolved")
                
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testResolveErrorProducerSuccess() {
        
        let result: Result<String> = .success("success")
        
        let expt = expectation(description: "error")
        
        let pipe = ValueProducer(result)
            |> resolveError(ThunkProducer<String>() {
                
                XCTFail()
                
                return "error"
                
            }) |> { (str: String) in
                
                XCTAssert(str == "success")
                
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testMapThrowToResult() {
        
        let expt = expectation(description: "error")
        
        let throwingFunc: () throws -> String = {
            
            throw MockError()
        }
        
        let pipe: Producible = producerMap(throwingFunc)
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
