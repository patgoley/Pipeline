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
        
        let bundle = Bundle(for: type(of: self))
        
        let pipeline = bundle.loadResource("animals", fileExtension: "json")
            |> JSONSerialization.deserializeArray
        
        pipeline.consumer = { result in
            
            switch result {
                
            case .success(let result):
                
                let expectedResult = [
                    "bird",
                    "cat",
                    "dog"
                ]
                
                XCTAssert(result as! [String] == expectedResult, "")
                
            case .error(let err):
                
                XCTAssert(false, "\(err)")
            }
        }
        
        pipeline.produce()
    }
    
    func testModelParser() {
        
        let bundle = Bundle(for: type(of: self))
        
        let pipeline = bundle.loadResource("user", fileExtension: "json")
            |> JSONSerialization.deserializeObject
            |> crashOnError
            |> User.createWithValues
        
        let parseExpectation = expectation(description: "parse")
        
        pipeline.consumer = { user in
            
            XCTAssert(user.firstName == "rick")
            XCTAssert(user.lastName == "sanchez")
            
            parseExpectation.fulfill()
        }
        
        pipeline.produce()
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}


struct User: Parseable {
    
    let firstName: String
    let lastName: String
    
    static func createWithValues(_ values: [String: AnyObject]) -> User {
        
        return User(
            firstName: values["firstName"] as! String,
            lastName: values["lastName"] as! String
        )
    }
}

