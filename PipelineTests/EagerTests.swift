//
//  EagerTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 7/2/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import XCTest
import Pipeline

class EagerTests: XCTestCase {

    func testEagerTransformerIsEager() {
        
        let expt = expectationWithDescription("success")
        
        let transformer = EagerTransformer<Int, String>() { (x: Int) in
            
            expt.fulfill()
            
            return "\(x)"
        }
        
        transformer.consume(123)
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testAnyTransformerIsLazy() {
        
        let transformer = AnyTransformer<Int, String>() { (x: Int) in
            
            XCTFail()
            
            return "\(x)"
        }
        
        transformer.consume(123)
    }
}
