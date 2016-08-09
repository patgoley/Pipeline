//
//  EagerTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 7/2/16.
//  Copyright © 2016 pipeline. All rights reserved.
//

import XCTest
import Pipeline

class EagerTests: XCTestCase {

    func testThunkTransformerIsEager() {
        
        let expt = expectationWithDescription("success")
        
        let transformer = ThunkTransformer<Int, String>() { (x: Int) in
            
            expt.fulfill()
            
            return "\(x)"
        }
        
        transformer.consume(123)
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
}
