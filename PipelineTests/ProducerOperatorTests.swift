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
        
        let pipe = { return 123 } |> AnyTransformer() { x in
            
            return x + 5
        }
        
        pipe.consumer = { x in
            
            XCTAssert(x == 128)
        }
        
        pipe.produce()
    }
    
    func testProducerConsumerType() {
        
        let anyProducer = AnyProducer(base: ValueProducer(123))
        
        let pipe = anyProducer |> AnyConsumer() { x in
            
            XCTAssert(x == 123)
        }
        
        pipe.produce()
    }
    
    func testProducerConsumerFunction() {
        
        let pipe = ValueProducer(123) |> { x in
            
            XCTAssert(x == 123)
        }
        
        pipe.produce()
    }
    
    func testProducerPipelineConsumerType() {
        
        let pipe = ValueProducer(123) |> { return $0 } |> AnyConsumer() { x in
            
            XCTAssert(x == 123)
        }
        
        pipe.produce()
    }
}
