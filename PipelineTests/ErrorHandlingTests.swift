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
    
    func testForceUnwrap() {
        
        let string: String? = "123"
        
        let pipe = ValueProducer(string) |> forceUnwrap |> { (x: String) in XCTAssert(x == "123") }
        
        pipe.produce()
    }
    
    func testForceUnwrapClosure() {
        
        let string: String? = "123"
        
        let pipe = ValueProducer(string) |> forceUnwrap { (str: String?) in str?.characters.count } |> { (x: Int) in x == 3  }
        
        pipe.produce()
    }
    
    func testDownCast() {
        
        let string = "123"
        
        let pipe = ValueProducer(string) |> downCast(Int.self) |> { _ in XCTAssert(false) }
        
        pipe.produce()
    }
    
    func testForceCast() {
        
        let anyObject: AnyObject = NSNumber(int: 3)
        
        let pipe = ValueProducer(anyObject) |> forceCast(NSNumber.self) |> { x in XCTAssert(x.intValue == 3) }
        
        pipe.produce()
    }
    
    func testSwallowError() {
        
        let result: Result<String> = .Error(NSError(domain: "", code: 0, userInfo: nil))
        
        let pipe = ValueProducer(result) |> swallowError() |> { _ in XCTAssert(false) }
        
        pipe.produce()
    }
}
