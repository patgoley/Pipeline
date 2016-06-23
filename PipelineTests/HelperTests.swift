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
        
        let pipe = AnyTransformer<String, String>() { str in
            
            return str
        
        } |> { (str: String) -> Int in
            
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
        
        let pipe = ValueProducer(string)
            |> guardUnwrap()
            |> { _ in XCTAssert(false) }
        
        pipe.produce()
    }
    
    func testGuardUnwrapNotNil() {
        
        let string: String? = "abc"
        
        let pipe = ValueProducer(string)
            |> guardUnwrap()
            |> { XCTAssert($0 == "abc") }
        
        pipe.produce()
    }
    
    func testGuardUnwrapWithClosure() {
        
        let pipe = guardUnwrap() { (person: Person) in
            
            return person.name?.characters.count
            
        } |> { _ in XCTAssert(false) }
        
        pipe.consume(Person(name: nil))
    }
    
    func testForceUnwrap() {
        
        let string: String? = "123"
        
        let pipe = ValueProducer(string)
            |> forceUnwrap
            |> { (x: String) in XCTAssert(x == "123") }
        
        pipe.produce()
    }
    
    func testForceUnwrapClosure() {
        
        let string: String? = "123"
        
        let pipe = ValueProducer(string)
            |> forceUnwrap { (str: String?) in str?.characters.count }
            |> { (x: Int) in x == 3  }
        
        pipe.produce()
    }
    
    func testDownCast() {
        
        let string = "123"
        
        let pipe = ValueProducer(string)
            |> downCast(Int.self)
            |> { _ in XCTAssert(false) }
        
        pipe.produce()
    }
    
    func testForceCast() {
        
        let anyObject: AnyObject = NSNumber(int: 3)
        
        let pipe = ValueProducer(anyObject)
            |> forceCast(NSNumber.self)
            |> { x in XCTAssert(x.intValue == 3) }
        
        pipe.produce()
    }
    
    func testOnNil() {
        
        let optional: String? = nil
        
        let expt = expectationWithDescription("nil")
        
        let pipe = ValueProducer(optional) |> onNil() {
            
            expt.fulfill()
            
        } |> { (str: String) in
                
            XCTFail()
        }
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testOnNilSome() {
        
        let optional: String? = "some"
        
        let expt = expectationWithDescription("nil")
        
        let pipe = ValueProducer(optional) |> onNil() {
            
            XCTFail()
            
            } |> { (str: String) in
                
                XCTAssert(str == "some")
                
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testResolveNil() {
        
        let optional: String? = nil
        
        let expt = expectationWithDescription("nil")
        
        let pipe = ValueProducer(optional)
            |> resolveNil() { return "abc" }
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
        
        let pipe = ValueProducer(optional)
            |> resolveNil() {
                
                XCTFail()
                
                return ""
                
            } |> { (str: String) in
                
                XCTAssert(str == "abc")
                
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
}
