//
//  UtilityTransformers.swift
//  Pipeline
//
//  Created by Patrick Goley on 11/16/16.
//

import Foundation


/*
 A transformer that filters values not meeting a certain condition.
 If a value is encountered that doesn't meet the condition, the
 execution of the Pipeline ends (no value is passed to the consumer).
 */

public final class FilterTransformer<T>: TransformerType  {
    
    public typealias InputType = T
    
    public typealias OutputType = T
    
    public var consumer: (OutputType -> Void)?
    
    public let condition: InputType -> Bool
    
    public init(condition: InputType -> Bool) {
        
        self.condition = condition
    }
    
    public func consume(input: InputType) {
        
        guard condition(input) else {
            
            return
        }
        
        consumer?(input)
    }
}

/*
 A transformer that attempts to unwrap optionals and pass along
 the unwrapped valued. If nil is encountered, the execution of the
 Pipeline ends (no value is passed to the consumer).
 */

public final class OptionalFilterTransformer<T, U>: TransformerType  {
    
    public typealias InputType = T
    
    public typealias OutputType = U
    
    public var consumer: (OutputType -> Void)?
    
    public let transform: InputType -> OutputType?
    
    public init(transform: InputType -> OutputType?) {
        
        self.transform = transform
    }
    
    public func consume(input: InputType) {
        
        guard let result = transform(input) else {
                
                return
        }
        
        consumer?(result)
    }
}

/*
 A transformer that provides a way to observe incoming values
 and pass them along. Useful for when you want to use a consumer
 to process something (perhaps log a value to the console) but
 don't want to terminate the Pipeline.
 */

public final class PassThroughTransformer<T>: TransformerType  {
    
    public typealias InputType = T
    
    public typealias OutputType = T
    
    public var consumer: (OutputType -> Void)?
    
    public let observe: InputType -> Void
    
    public init(observe: InputType -> Void) {
        
        self.observe = observe
    }
    
    public func consume(input: InputType) {
        
        observe(input)
        
        consumer?(input)
    }
}

/*
 Encapsulates an asynchronous transformer operation. Users of this
 class must provide a function that takes an input and a completion
 closure for the output
 */

public final class AsyncTransformer<T, U>: TransformerType  {
    
    public typealias InputType = T
    
    public typealias OutputType = U
    
    public var consumer: (OutputType -> Void)?
    
    public let execute: (InputType, (OutputType -> Void)) -> Void
    
    public init(execute: (InputType, (OutputType -> Void)) -> Void) {
        
        self.execute = execute
    }
    
    public func consume(input: InputType) {
        
        execute(input) { output in
         
            self.consumer?(output)
        }
    }
}


final class FlatMapTransformer<T, U>: TransformerType, Disposable  {
    
    typealias InputType = T
    
    typealias OutputType = U
    
    var consumer: (OutputType -> Void)?
    
    private var disposable: Disposable?
    
    private let execute: (InputType, (OutputType -> Void)) -> Disposable
    
    init<C: ConsumableType where C.OutputType == OutputType>(flatMap: (InputType -> C)) {
        
        self.execute = { (input, consumer) in
         
            let consumable = flatMap(input)
            
            consumable.consumer = consumer
            
            return AnyDisposable.create(consumable)
        }
    }
    
    init<P: ProducerType where P.OutputType == OutputType>(flatMap: (InputType -> P)) {
        
        self.execute = { (input, consumer) in
            
            let producer = flatMap(input)
            
            producer.produce(consumer)
            
            return AnyDisposable.create(producer)
        }
    }
    
    init(execute: (InputType, (OutputType -> Void)) -> Disposable) {
        
        self.execute = execute
    }
    
    func consume(input: InputType) {
        
        dispose()
        
        disposable = execute(input) { [weak self] output in
            
            self?.consumer?(output)
        }
    }
    
    func dispose() {
        
        disposable?.dispose()
        disposable = nil
    }
}

/*
 A version of AnyTransformer that always executes it's transform
 even if no consumer is listening to receive the result. This is
 useful for operations that generate an ignorable result.
 */
@available(*, deprecated)
public final class EagerTransformer<T, U>: TransformerType {
    
    public typealias InputType = T
    
    public typealias OutputType = U
    
    public var consumer: (OutputType -> Void)?
    
    public let transform: InputType -> OutputType
    
    public init(transform: InputType -> OutputType) {
        
        self.transform = transform
    }
    
    public func consume(input: InputType) {
        
        let result = transform(input)
        
        consumer?(result)
    }
}