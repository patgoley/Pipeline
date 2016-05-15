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
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("animals", withExtension: "json")!
        
        let data = NSData(contentsOfURL: url)!
        
        let deserializer = NSJSONSerialization.deserializer()
        
        switch deserializer.transform(data) {
            
        case .Success(let result as Array<String>):
            
            let expectedResult = [
                "bird",
                "cat",
                "dog"
            ]
            
            XCTAssert(result == expectedResult, "")
            
        case .Error(let err):
            
            XCTAssert(false, "\(err)")
        
        default:
            
            XCTAssert(false, "unexpected JSON structure")
        }
    }
}
