//
//  TransformerOperatorTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/24/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import XCTest
import Pipeline

class TransformerOperatorTests: XCTestCase {
    
    let inputValue = 321
    
    func testTransformerConsumerFunction() {
        
        let pipe = ThunkTransformer() { (x: Int) in return x + 5 } |> { (x: Int) in
            
            XCTAssert(x == 326)
        }
        
        pipe.consume(inputValue)
    }
    
    func testTransformerTypeTransformerFunction() {
        
        let pipe = ThunkTransformer() { (x: Int) in return x + 5 } |> { (x: Int) in return x * 2 }
        
        pipe.then { x in
                
            XCTAssert(x == 652)
        }
        
        pipe.consume(inputValue)
    }
    
    func testTransformerPipelineTransformerFunction() {
        
        let pipe = ThunkTransformer() { (x: Int) in return x + 5 } |> { (x: Int) in return x * 2 }
        
        let finalPipe = pipe |> { (x: Int) in return x + 1 }
        
        finalPipe.consumer = {
            
            XCTAssert($0 == 653)
        }
        
        finalPipe.consume(inputValue)
    }
    
    func testTransformerFunctionTransformerType() {
        
        let pipe = { (x: Int) in return x + 5 } |> ThunkTransformer() { (x: Int) in return x * 2 }
        
        pipe.then { x in
            
            XCTAssert(x == 652)
        }
        
        pipe.consume(inputValue)
    }
    
    func testTransformerPipelineConsumerType() {
        
        let pipe = ThunkTransformer() { (x: Int) in return x + 5 } |> { (x: Int) in return x * 2 }
        
        let _ = pipe |> ThunkTransformer() { x in
            
            XCTAssert(x == 652)
        }
        
        pipe.consume(inputValue)
    }
    
    func testTransformerPipelineConsumerFunction() {
        
        let pipe = ThunkTransformer() { return $0 + 5 } |> { return $0 * 2 }
        
        let _ = pipe |> { (x: Int) in
            
            XCTAssert(x == 652)
        }
        
        pipe.consume(inputValue)
    }
    
    func testTwoTransformerFunctions() {
        
        let pipe = { (x: Int) in return x + 5 } |> { (x: Int) in return "\(x)" } |> { (x: String) in
            
            XCTAssert(x == "326")
        }
        
        pipe.consume(inputValue)
    }
    
    func testTwoTransformerTypes() {
        
        let pipe = ThunkTransformer() { (x: Int) in return x + 5 }
            |> ThunkTransformer() { (x: Int) in return "\(x)" }
            |> { (x: String) in
            
            XCTAssert(x == "326")
        }
        
        pipe.consume(inputValue)
    }
    
    func testTransformerPipelineTransformerType() {
        
        let head = ThunkTransformer() { (x: Int) in return x + 5 }
        
        let pipe = Pipeline(head: head)
        
        let finalPipe = pipe
            |> ThunkTransformer() { (x: Int) in return "\(x)" }
            |> { (x: String) in
            
            XCTAssert(x == "326")
        }
        
        finalPipe.consume(inputValue)
    }
    
    func testTransformerFunctionConsumerFunction() {
        
        let pipe = { (x: Int) in return "\(x)" }
            |> { (x: String) in
            
            XCTAssert(x == "321")
        }
        
        pipe.consume(inputValue)
    }
    
    func testTransformerFunctionConsumerType() {
        
        let pipe = { (x: Int) in return "\(x)" } |> ThunkTransformer() { (x: String) in
            
            XCTAssert(x == "321")
        }
        
        pipe.consume(inputValue)
    }
}
