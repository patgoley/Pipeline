//
//  OperatorTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/21/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import XCTest
import Pipeline

class OperatorTests: XCTestCase {

    func testPrecedence() {
        
        // won't compile if |> precedence is lower than =
        
        let pipe: Pipeline<Void, String>
        
        pipe = ValueProducer("123") |> AnyTransformer<String, String>() { x in return x }
        
        _ = { pipe }
        
        XCTAssert(true)
    }
}
