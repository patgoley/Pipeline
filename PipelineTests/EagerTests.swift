//
//  EagerTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 7/2/16.
//

import XCTest
import Pipeline

class EagerTests: XCTestCase {

    func testEagerTransformerIsEager() {
        
        let expt = expectation(description: "success")
        
        let transformer = EagerTransformer<Int, String>() { (x: Int) in
            
            expt.fulfill()
            
            return "\(x)"
        }
        
        transformer.consume(123)
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
