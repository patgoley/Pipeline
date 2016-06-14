//
//  HelperTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/20/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import XCTest
@testable import Pipeline

struct MockError: ErrorType { }

class HelperTests: XCTestCase {
    
    func testMap() {
        
        let string = "abc"
        
        let pipe = ValueProducer(string)
            |> map() { $0.characters.count }
            |> { count in
                
                XCTAssert(count == 3)
        }
        
        pipe.produce()
    }
    
    func testFilter() {
        
        let pipe = filter() { $0.characters.count == 3 }
            |> { (string: String) in
                
                XCTAssert(string.characters.count == 3)
        }
        
        pipe.consume("abc")
        
        pipe.consume("a")
        
        pipe.consume("abcd")
    }
    
    func testThrowingMap() {
        
        let pipe = map() { (str: String) -> Int in
            
            if str.characters.count == 3 {
                
                throw MockError()
                
            } else {
                
                return str.characters.count
            }
            
        }
        
        pipe.consumer = { (result: Result<Int>) in
            
            switch result {
                
            case .Success(_): XCTFail()
            default: break
            }
        }
        
        pipe.consume("abc")
        
        pipe.consumer = { (result: Result<Int>) in
            
            switch result {
                
            case .Error(_): XCTFail()
            default: break
            }
        }
        
        pipe.consume("a")
    }

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
        
        let pipe = ValueProducer(result) |> swallowError(log: "found error") |> { _ in XCTAssert(false) }
        
        pipe.produce()
    }
}
