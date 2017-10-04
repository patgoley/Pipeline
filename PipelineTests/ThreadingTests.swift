//
//  ThreadingTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/20/16.
//

import XCTest
import Pipeline

class ThreadingTests: XCTestCase {

    func testEnsureMainThread() {
        
        let expt = expectation(description: "async")
        
        DispatchQueue.global(qos: .default).async {
            
            XCTAssert(!Thread.isMainThread)
            
            let pipe = ValueProducer(123) |> ensureMainThread() |> { _ in
                
                XCTAssert(Thread.isMainThread)
                
                expt.fulfill()
            }
            
            pipe.produce()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testAsyncBackground() {
        
        let expt = expectation(description: "async")
        
        XCTAssert(Thread.isMainThread)
        
        let pipe = ValueProducer("abc") |> asyncBackgroundThread() |> { _ in
            
            XCTAssert(!Thread.isMainThread)
            
            expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectations(timeout: 3, handler: nil)
    }

}
