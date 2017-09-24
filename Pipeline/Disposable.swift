//
//  Disposable.swift
//  Pipeline
//
//  Created by Patrick Goley on 9/10/17.
//
//

import Foundation


public protocol Disposable {
    
    func dispose()
}


class AnyDisposable: Disposable {
    
    static func create(any: Any) -> Disposable {
        
        return any as? Disposable ?? AnyDisposable(any)
    }
    
    private var storage: Any?
    
    init(_ any: Any) {
        
        storage = any
    }
    
    func dispose() {
        
        if let disposable = storage as? Disposable {
            
            disposable.dispose()
        }
        
        storage = nil
    }
}


class DisposeBag: Disposable {
    
    private var contents: [Any]? = []
    
    func add(disposable: Disposable) {
        
        contents?.append(disposable)
    }
    
    func dispose() {
        
        guard let contents = contents else {
            
            return
        }
        
        for item in contents {
            
            if let disposable = item as? Disposable {
                
                disposable.dispose()
            }
        }
        
        self.contents = nil
    }
}


extension Disposable {
    
    func addToDisposeBag(disposeBag: DisposeBag) {
        
        disposeBag.add(self)
    }
}