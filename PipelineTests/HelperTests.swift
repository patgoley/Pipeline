//
//  HelperTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/20/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import XCTest
@testable import Pipeline

struct Person {
    
    var name: String?
}

struct MockError: ErrorType { }

class HelperTests: XCTestCase {
    
    func testFilter() {
        
        let pipe = filter() { (str: String) -> Bool in str.characters.count == 3 }
            |> { (string: String) in
                
                XCTAssert(string.characters.count == 3)
        }
        
        pipe.consume("abc")
        
        pipe.consume("a")
        
        pipe.consume("abcd")
    }
    
    func testUnless() {
        
        let pipe = unless() { (str: String) -> Bool in str.characters.count == 3 }
            |> { (string: String) in
                
                XCTAssert(string.characters.count != 3)
        }
        
        pipe.consume("abc")
        
        pipe.consume("a")
        
        pipe.consume("abcd")
    }

    func testGuardUnwrap() {
        
        let string: String? = nil
        
        let pipe = ValueProducer<String?>(string)
            |> guardUnwrap()
            |> { _ in XCTAssert(false) }
        
        pipe.produce()
    }
    
    func testGuardUnwrapNotNil() {
        
        let string: String? = "abc"
        
        let pipe = ValueProducer<String?>(string)
            |> guardUnwrap()
            |> { (str: String) in XCTAssert(str == "abc") }
        
        pipe.produce()
    }
    
    func testGuardUnwrapWithClosure() {
        
        let pipe = guardUnwrap() { (person: Person) -> Int? in
            
            return person.name?.characters.count
            
            } |> { (x: Int) in XCTAssert(false) }
        
        pipe.consume(Person(name: nil))
    }
    
    func testForceUnwrap() {
        
        let string: String? = "123"
        
        let pipe = ValueProducer<String?>(string)
            |> forceUnwrap
            |> { (x: String) in XCTAssert(x == "123") }
        
        pipe.produce()
    }
    
    func testForceUnwrapClosure() {
        
        let string: String? = "123"
        
        let pipe = ValueProducer<String?>(string)
            |> forceUnwrap { (str: String?) -> Int? in return str?.characters.count }
            |> { (x: Int) in x == 3  }
        
        pipe.produce()
    }
    
    func testDownCast() {
        
        let string = "123"
        
        let pipe = ValueProducer<String>(string)
            |> downCast(Int.self)
            |> { (x: Int) in XCTAssert(false) }
        
        pipe.produce()
    }
    
    func testForceCast() {
        
        let anyObject: AnyObject = NSNumber(int: 3)
        
        let pipe = ValueProducer<AnyObject>(anyObject)
            |> forceCast(NSNumber.self)
            |> { (x: NSNumber) in XCTAssert(x.intValue == 3) }
        
        pipe.produce()
    }
    
    func testResolveNil() {
        
        let optional: String? = nil
        
        let expt = expectationWithDescription("nil")
        
        let pipe = ValueProducer<String?>(optional)
            |> resolveNil() { () -> String in return "abc" }
            |> { (str: String) in
                
            XCTAssert(str == "abc")
            
            expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testResolveNilSome() {
        
        let optional: String? = "abc"
        
        let expt = expectationWithDescription("some")
        
        let pipe = ValueProducer<String?>(optional)
            |> resolveNil() { () -> String in
                
                XCTFail()
                
                return ""
                
            } |> { (str: String) in
                
                XCTAssert(str == "abc")
                
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testResolveNilProducer() {
        
        let optional: String? = nil
        
        let expt = expectationWithDescription("nil")
        
        let pipe = ValueProducer<String?>(optional)
            |> resolveNil(ThunkProducer<String>() { return "abc" })
            |> { (str: String) in
                
                XCTAssert(str == "abc")
                
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testResolveNilProducerSome() {
        
        let optional: String? = "abc"
        
        let expt = expectationWithDescription("some")
        
        let pipe = ValueProducer<String?>(optional)
            |> resolveNil(ThunkProducer<String>() {
                
                XCTFail()
                
                return ""
                
            }) |> { (str: String) in
                
                XCTAssert(str == "abc")
                
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
}
