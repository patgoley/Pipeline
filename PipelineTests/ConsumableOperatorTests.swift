//
//  ConsumableOperatorTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/24/16.
//

import XCTest
import Pipeline

class ConsumableOperatorTests: XCTestCase {

    func testConsumeableTransformerType() {
        
        let producer = ThunkProducer() { return 123 }
        
        let consumable = AnyConsumable(base: producer)
        
        let pipe = consumable |> AnyTransformer<Int, Int>() { (x: Int) in
            
            return x + 5
        }
        
        pipe.consumer = {
            
            XCTAssert($0 == 128)
        }
        
        producer.produce()
    }
    
    func testConsumeableTransformerFunction() {
        
        let producer = ThunkProducer<Int>() { return 123 }
        
        let consumable = AnyConsumable<Int>(base: producer)
        
        let pipe = consumable |> { (x: Int) -> Int in
            
            return x + 5
        }
        
        pipe.consumer = {
            
            XCTAssert($0 == 128)
        }
        
        producer.produce()
    }
    
    func testConsumeableConsumerType() {
        
        let producer = ThunkProducer<Int>() { return 123 }
        
        let consumable = AnyConsumable<Int>(base: producer)
        
        let _ = consumable |> AnyConsumer<Int>() { (x: Int) in
            
            XCTAssert(x == 123)
        }
        
        producer.produce()
    }
    
    func testConsumeablePipelineConsumerType() {
        
        let producer = ThunkProducer<Int>() { return 123 }
        
        let consumable = AnyConsumable<Int>(base: producer)
        
        let pipe = ConsumablePipeline<Int>(head: consumable)
        
        let _ = pipe
            |> integerIdentity
            |> AnyTransformer<Int, Int>(transform: integerIdentity)
            |> AnyConsumer<Int>() { x in
            
            XCTAssert(x == 123)
        }
        
        producer.produce()
    }
    
    func testConsumeablePipelineConsumerFunction() {
        
        let producer = ThunkProducer<Int>() { return 123 }
        
        let consumable = AnyConsumable<Int>(base: producer)
        
        let pipe = ConsumablePipeline<Int>(head: consumable)
        
        let _ = pipe
            |> integerIdentity
            |> AnyConsumer<Int>() { (x: Int) in
            
            XCTAssert(x == 123)
        }
        
        producer.produce()
    }
    
    func testConsumeableThrowingFunction() {
        
        let producer = ThunkProducer<Int>() { return 123 }
        
        let consumable = AnyConsumable<Int>(base: producer)
        
        let expt = expectationWithDescription("error")
        
        let _ = consumable |> { (x: Int) throws -> String in
            
                if x == 123 {
                    
                    throw MockError()
                }
                
                return ""
            
            } |> { (result: Result<String>) in
                
                switch result {
                case .Error(let err):
                    
                    XCTAssert(err is MockError)
                    
                    expt.fulfill()
                    
                default: XCTFail()
                }
            }
        
        producer.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testConsumeablePipelineThrowingFunction() {
        
        let producer = ThunkProducer<Int>() { return 123 }
        
        let consumable = AnyConsumable<Int>(base: producer)
        
        let expt = expectationWithDescription("error")
        
        let _ = consumable
            |> AnyTransformer<Int,Int>(transform: integerIdentity)
            |> { (x: Int) throws -> String in
            
            if x == 123 {
                
                throw MockError()
            }
            
            return ""
            
            } |> { (result: Result<String>) -> Void in
                
                switch result {
                case .Error(let err):
                    
                    XCTAssert(err is MockError)
                    
                    expt.fulfill()
                    
                default: XCTFail()
                }
            }
        
        producer.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testConsumeablePipelineThrowingTransformerFunction() {
        
        let producer = ThunkProducer<Int>() { return 123 }
        
        let consumable = AnyConsumable<Int>(base: producer)
        
        let _ = consumable
            |> AnyTransformer<Int, Int>(transform: integerIdentity)
            |> integerIdentity
            |> { (x: Int) throws -> Int in
                
                throw MockError()
                
            } |> { (result: Result<Int>) in
               
                switch result{
                    
                case .Success(_): XCTFail()
                default: break
                }
            }
        
        producer.produce()
    }
    
    func testConsumeablePipelineTransformerType() {
        
        let producer = ThunkProducer<Int>() { return 123 }
        
        let consumable = AnyConsumable<Int>(base: producer)
        
        let _ = consumable
            |> AnyTransformer<Int, Int>(transform: integerIdentity)
            |> AnyTransformer<Int, Int>(transform: integerIdentity)
            |> { (x: Int) in
                
                XCTAssert(x == 123)
        }
        
        producer.produce()
    }
    
    func testConsumeableOptionalMap() {
        
        let producer = ThunkProducer<Int?>() { return nil }
        
        let expt = expectationWithDescription("nil")
        
        let pipe = producer |> optionalMap({ (int: Int) -> Int in int + 5 })
        
        pipe.consumer = { (x: Int?) in
            
            XCTAssertNil(x)
            
            expt.fulfill()
        }
        
        producer.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testConsumeableOptionalMapWithValue() {
        
        let producer = ThunkProducer<Int?>() { return 123 }
        
        let expt = expectationWithDescription("value")
        
        let pipe = producer |> optionalMap({ (int: Int) -> Int in int + 5 })
        
        pipe.consumer = { (x: Int?) in
            
            if let val = x {
                
                XCTAssert(val == 128)
                
            } else {
                
                XCTFail()
            }
            
            expt.fulfill()
        }
        
        producer.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testConsumeableTransformerOptionalMap() {
        
        let producer = ThunkProducer<Int?>() { return nil }
        
        let expt = expectationWithDescription("nil")
        
        let pipe = producer |> optionalMap(AnyTransformer<Int, Int>() { (int: Int) -> Int in int + 5 })
        
        pipe.consumer = { (x: Int?) in
            
            XCTAssertNil(x)
            
            expt.fulfill()
        }
        
        producer.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testConsumeableTransformerOptionalMapWithValue() {
        
        let producer = ThunkProducer<Int?>() { return 123 }
        
        let expt = expectationWithDescription("value")
        
        let pipe = producer |> optionalMap(AnyTransformer<Int, Int>() { (int: Int) -> Int in int + 5 })
        
        pipe.consumer = { (x: Int?) in
            
            if let val = x {
                
                XCTAssert(val == 128)
                
            } else {
                
                XCTFail()
            }
            
            expt.fulfill()
        }
        
        producer.produce()
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
}
