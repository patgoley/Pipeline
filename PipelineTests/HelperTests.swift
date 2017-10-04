//
//  HelperTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/20/16.
//

import XCTest
@testable import Pipeline

struct Person {
    
    var name: String?
}

struct MockError: Error { }

class HelperTests: XCTestCase {
    
    func testMap() {
        
        let string = "abc"
        
        let pipe = ValueProducer<String>(string)
            |> map() { (str: String) -> Int in str.characters.count }
            |> { (count: Int) in
                
                XCTAssert(count == 3)
        }
        
        pipe.produce()
    }
    
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
    
    func testThrowingMap() {
        
        let pipe = AnyTransformer<String, String>() { str in
            
            return str
        
        } |> { (str: String) throws -> Int in
            
            if str.characters.count == 3 {
                
                throw MockError()
                
            } else {
                
                return str.characters.count
            }
        }
        
        pipe.consumer = { (result: Result<Int>) in
            
            switch result {
                
            case .success(_): XCTFail()
            default: break
            }
        }
        
        pipe.consume("abc")
        
        pipe.consumer = { (result: Result<Int>) in
            
            switch result {
                
            case .error(_): XCTFail()
            default: break
            }
        }
        
        pipe.consume("a")
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
        
        let anyObject: AnyObject = NSNumber(value: 3 as Int32)
        
        let pipe = ValueProducer<AnyObject>(anyObject)
            |> forceCast(NSNumber.self)
            |> { (x: NSNumber) in XCTAssert(x.int32Value == 3) }
        
        pipe.produce()
    }
    
    func testResolveNil() {
        
        let optional: String? = nil
        
        let expt = expectation(description: "nil")
        
        let pipe = ValueProducer<String?>(optional)
            |> resolveNil() { () -> String in return "abc" }
            |> { (str: String) in
                
            XCTAssert(str == "abc")
            
            expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testResolveNilSome() {
        
        let optional: String? = "abc"
        
        let expt = expectation(description: "some")
        
        let pipe = ValueProducer<String?>(optional)
            |> resolveNil() { () -> String in
                
                XCTFail()
                
                return ""
                
            } |> { (str: String) in
                
                XCTAssert(str == "abc")
                
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testResolveNilProducer() {
        
        let optional: String? = nil
        
        let expt = expectation(description: "nil")
        
        let pipe = ValueProducer<String?>(optional)
            |> resolveNil(ThunkProducer<String>() { return "abc" })
            |> { (str: String) in
                
                XCTAssert(str == "abc")
                
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testResolveNilProducerSome() {
        
        let optional: String? = "abc"
        
        let expt = expectation(description: "some")
        
        let pipe = ValueProducer<String?>(optional)
            |> resolveNil(ThunkProducer<String>() {
                
                XCTFail()
                
                return ""
                
            }) |> { (str: String) in
                
                XCTAssert(str == "abc")
                
                expt.fulfill()
        }
        
        pipe.produce()
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
