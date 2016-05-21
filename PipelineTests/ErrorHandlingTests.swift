//
//  ErrorHandlingTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/20/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import XCTest
@testable import Pipeline

class ErrorHandlingTests: XCTestCase {

    func testGuardUnwrap() {
        
        let string: String? = nil
        
        let pipe = ValueProducer(string) |> guardUnwrap() |> { _ in XCTAssert(false) }
        
        pipe.produce()
    }

}
