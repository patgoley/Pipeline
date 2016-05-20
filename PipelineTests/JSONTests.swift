//
//  JSONTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import XCTest
import Pipeline

class JSONTests: XCTestCase {

    func testSerializer() {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        
        let pipeline = bundle.loadResource("animals", fileExtension: "json") |> NSJSONSerialization.deserializeArray
        
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
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("user", withExtension: "json")!
        
        let data = NSData(contentsOfURL: url)!
        
        let parserPipeline = ModelParser<User>.JSONParser()
        
        let parseExpectation = expectationWithDescription("parse")
        
        parserPipeline.consumer = { user in
            
            XCTAssert(true)
            
            parseExpectation.fulfill()
        }
        
        parserPipeline.consume(data)
        
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

