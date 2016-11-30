//
//  TransformerTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/24/16.
//

import XCTest
import Pipeline

class TransformerTests: XCTestCase {
    
    func testPassThroughTransformer() {
        
        let pipe = ValueProducer("123")
            |> PassThroughTransformer() { (x: String) in XCTAssert(x == "123") }
            |> { (x: String) in XCTAssert(x == "123") }
        
        pipe.produce()
    }
    
    func testAnyTransformerNoConsumer() {
        
        let transformer = AnyTransformer<String, String>() { (x: String) in
            
            XCTAssert(false)
            
            return x + "4"
        }
        
        transformer.consume("123")
    }
    
    func testAsyncTransformerNoConsumer() {
        
        let transformer = AsyncTransformer() { (x: String, consumer: String -> Void) in
            
            XCTAssert(false)
            
            consumer(x + "4")
        }
        
        transformer.consume("123")
    }
}
