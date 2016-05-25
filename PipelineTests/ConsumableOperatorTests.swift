//
//  ConsumableOperatorTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/24/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import XCTest
import Pipeline

class ConsumableOperatorTests: XCTestCase {

    func testConsumeableTransformerType() {
        
        let producer = ThunkProducer() { return 123 }
        
        let consumable = AnyConsumable(base: producer)
        
        let pipe = consumable |> AnyTransformer() { x in
            
            return x + 5
        }
        
        pipe.consumer = {
            
            XCTAssert($0 == 128)
        }
        
        producer.produce()
    }
    
    func testConsumeableTransformerFunction() {
        
        let producer = ThunkProducer() { return 123 }
        
        let consumable = AnyConsumable(base: producer)
        
        let pipe = consumable |> { x in
            
            return x + 5
        }
        
        pipe.consumer = {
            
            XCTAssert($0 == 128)
        }
        
        producer.produce()
    }
    
    func testConsumeableConsumerType() {
        
        let producer = ThunkProducer() { return 123 }
        
        let consumable = AnyConsumable(base: producer)
        
        let _ = consumable |> AnyConsumer() { x in
            
            XCTAssert(x == 123)
        }
        
        producer.produce()
    }
    
    func testConsumeablePipelineConsumerType() {
        
        let producer = ThunkProducer() { return 123 }
        
        let consumable = AnyConsumable(base: producer)
        
        let _ = consumable |> { return $0 } |> AnyConsumer() { x in
            
            XCTAssert(x == 123)
        }
        
        producer.produce()
    }
    
    func testConsumeablePipelineConsumerFunction() {
        
        let producer = ThunkProducer() { return 123 }
        
        let consumable = AnyConsumable(base: producer)
        
        let _ = consumable |> { return $0 } |> { x in
            
            XCTAssert(x == 123)
        }
        
        producer.produce()
    }
}
