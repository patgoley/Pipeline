//
//  JoinTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 6/18/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import XCTest
import Pipeline

class JoinTests: XCTestCase {
    
    func testTwoJoin() {
        
        let intTransformer = AnyTransformer<Int, Int>() { (x: Int) in return x }
        let stringTransformer = AnyTransformer<String, String>() { (str: String) in return str }
        
        let joinedPipeline = join(intTransformer, second: stringTransformer)
        
        joinedPipeline.consumer = { (values: (first: Int?, second: String?)) in
            
            XCTAssert(values.first == 123 && values.second == nil)
        }
        
        intTransformer.consume(123)
        
        joinedPipeline.consumer = { (values: (first: Int?, second: String?)) in
            
            XCTAssert(values.first == 123 && values.second == "abc")
        }
        
        stringTransformer.consume("abc")
    }
    
    func testThreeJoin() {
        
        let intTransformer = AnyTransformer<Int, Int>() { (x: Int) in return x }
        let stringTransformer = AnyTransformer<String, String>() { (str: String) in return str }
        let doubleTransformer = AnyTransformer<Double, Double>() { (x: Double) in return x }
        
        let joinedPipeline = join(intTransformer, second: stringTransformer, third: doubleTransformer)
        
        joinedPipeline.consumer = { (values: (first: Int?, second: String?, third: Double?)) in
            
            XCTAssert(values.first == 123 && values.second == nil && values.third == nil)
        }
        
        intTransformer.consume(123)
        
        joinedPipeline.consumer = { (values: (first: Int?, second: String?, third: Double?)) in
            
            XCTAssert(values.first == 123 && values.second == "abc" && values.third == nil)
        }
        
        stringTransformer.consume("abc")
        
        joinedPipeline.consumer = { (values: (first: Int?, second: String?, third: Double?)) in
            
            XCTAssert(values.first == 123 && values.second == "abc" && values.third == 5.0)
        }
        
        doubleTransformer.consume(5.0)
    }
}
