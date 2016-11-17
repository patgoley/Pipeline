//
//  JSONTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//

import XCTest
import Pipeline

class JSONTests: XCTestCase {

    func testSerializer() {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        
        let pipeline = bundle.loadResource("animals", fileExtension: "json")
            |> NSJSONSerialization.deserializeArray
        
        pipeline.consumer = { result in
            
            switch result {
                
            case .Success(let result):
                
                let expectedResult = [
                    "bird",
                    "cat",
                    "dog"
                ]
                
                XCTAssert(result as! [String] == expectedResult, "")
                
            case .Error(let err):
                
                XCTAssert(false, "\(err)")
            }
        }
        
        pipeline.produce()
    }
    
    func testModelParser() {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        
        let pipeline = bundle.loadResource("user", fileExtension: "json")
            |> NSJSONSerialization.deserializeObject
            |> crashOnError
            |> User.createWithValues
        
        let parseExpectation = expectationWithDescription("parse")
        
        pipeline.consumer = { user in
            
            XCTAssert(user.firstName == "rick")
            XCTAssert(user.lastName == "sanchez")
            
            parseExpectation.fulfill()
        }
        
        pipeline.produce()
        
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }
}


struct User: Parseable {
    
    let firstName: String
    let lastName: String
    
    static func createWithValues(values: [String: AnyObject]) -> User {
        
        return User(
            firstName: values["firstName"] as! String,
            lastName: values["lastName"] as! String
        )
    }
}

