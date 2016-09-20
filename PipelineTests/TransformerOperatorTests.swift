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
    
    func testTransformerPipelineThrowingFunction() {
        
        let expt = expectation(description: "error")
        
        let pipe = { (str: String) in return str }
            |> AnyTransformer<String, String>() { str in return str }
            |> { (str: String) throws -> Int in
            
                if str.characters.count == 3 {
                    
                    throw MockError()
                    
                } else {
                    
                    return str.characters.count
                }
                
            } |> { (result: Result<Int>) in
                
                switch result {
                case .success(_): XCTFail()
                default: break
                }
                
                expt.fulfill()
            }
        
        pipe.consume("abc")
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testThrowingFunctionTransformerType() {
        
        let throwingProducer: () throws -> String = {
            
            throw MockError()
        }
            
        let pipe = throwingProducer
            |> AnyTransformer() { (result: Result<String>) -> String in
                
            switch result {
                
            case .success(let str):
                XCTFail()
                return str
            default: break
            }
                
            return ""
                
        } |> { (str: String) in
                    
            print(str)
        }
        
        pipe.produce()
    }
}
