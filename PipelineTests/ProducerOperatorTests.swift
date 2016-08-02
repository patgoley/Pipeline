//
//  ProcuderOperatorTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/24/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import XCTest
import Pipeline

class ProducerOperatorTests: XCTestCase {
    
    func testProducerTransformerType() {
        
        let pipe = { () -> Int in return 123 } |> ThunkTransformer<Int, Int>() { (x: Int) in
            
            return x + 5
        }
        
        pipe.consumer = { (x: Int) in
            
            XCTAssert(x == 128)
        }
        
        pipe.produce()
    }
    
    func testProducerConsumerType() {
        
        let anyProducer = AnyTransformer(base: ValueProducer<Int>(123))
        
        let pipe = anyProducer |> ThunkTransformer<Int, Void>() { (x: Int) in
            
            XCTAssert(x == 123)
        }
        
        pipe.produce()
    }
    
    func testProducerConsumerFunction() {
        
        let pipe = ValueProducer<Int>(123) |> { (x: Int) in
            
            XCTAssert(x == 123)
        }
        
        pipe.produce()
    }
}
