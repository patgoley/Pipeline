//
//  TransformerTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/24/16.
//  Copyright © 2016 pipeline. All rights reserved.
//

import XCTest
import Pipeline

class TransformerTests: XCTestCase {
    
    func testPassThroughTransformer() {
        
        let pipe = ValueProducer("123")
            |> PassThroughTransformer() { (x: String) in XCTAssert(x == "123") }
            |> { (x: String) in XCTAssert(x == "123") }
        
        pipe.produce()
    }
}
