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
        
        let expt = expectationWithDescription("async")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            XCTAssert(!NSThread.isMainThread())
            
            let pipe = ValueProducer(123) |> ensureMainThread() |> { _ in
                
                XCTAssert(NSThread.isMainThread())
                
                expt.fulfill()
            }
            
            pipe.produce()
        }
        
        waitForExpectationsWithTimeout(3, handler: nil)
    }

    func testAsyncBackground() {
        
        let expt = expectationWithDescription("async")
        
        XCTAssert(NSThread.isMainThread())
        
        let pipe = ValueProducer("abc") |> asyncBackgroundThread() |> { _ in
            
            XCTAssert(!NSThread.isMainThread())
            
            expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(3, handler: nil)
    }

}
