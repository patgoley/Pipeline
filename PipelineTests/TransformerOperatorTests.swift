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
        
        let pipe = AnyTransformer() { (x: Int) in return x + 5 } |> { (x: Int) in
            
            XCTAssert(x == 326)
        }
        
        pipe.consume(inputValue)
    }
    
    func testTransformerTypeTransformerFunction() {
        
        let pipe = AnyTransformer() { (x: Int) in return x + 5 } |> { (x: Int) in return x * 2 }
        
        pipe.finally { x in
                
            XCTAssert(x == 652)
        }
        
        pipe.consume(inputValue)
    }
    
    func testTransformerPipelineTransformerFunction() {
        
        let pipe = AnyTransformer() { (x: Int) in return x + 5 } |> { (x: Int) in return x * 2 }
        
        let finalPipe = pipe |> { (x: Int) in return x + 1 }
        
        finalPipe.consumer = {
            
            XCTAssert($0 == 653)
        }
        
        finalPipe.consume(inputValue)
    }
    
    func testTransformerFunctionTransformerType() {
        
        let pipe = { (x: Int) in return x + 5 } |> AnyTransformer() { (x: Int) in return x * 2 }
        
        pipe.finally { x in
            
            XCTAssert(x == 652)
        }
        
        pipe.consume(inputValue)
    }
    
    func testTransformerPipelineConsumerType() {
        
        let pipe = AnyTransformer() { (x: Int) in return x + 5 } |> { (x: Int) in return x * 2 }
        
        let _ = pipe |> AnyConsumer() { x in
            
            XCTAssert(x == 652)
        }
        
        pipe.consume(inputValue)
    }
    
    func testTransformerPipelineConsumerFunction() {
        
        let pipe = AnyTransformer() { return $0 + 5 } |> { return $0 * 2 }
        
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
        
        let pipe = AnyTransformer() { (x: Int) in return x + 5 }
            |> AnyTransformer() { (x: Int) in return "\(x)" }
            |> { (x: String) in
            
            XCTAssert(x == "326")
        }
        
        pipe.consume(inputValue)
    }
    
    func testTransformerPipelineTransformerType() {
        
        let head = AnyTransformer() { (x: Int) in return x + 5 }
        
        let pipe = TransformerPipeline(head: head)
        
        let finalPipe = pipe
            |> AnyTransformer() { (x: Int) in return "\(x)" }
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
        
        let pipe = { (x: Int) in return "\(x)" } |> AnyConsumer() { (x: String) in
            
            XCTAssert(x == "321")
        }
        
        pipe.consume(inputValue)
    }
}
