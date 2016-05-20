//
//  RESTClient.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/20/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

public protocol RESTAPI {
    
    static var baseURL: String { get }
}

public protocol RESTResource {
    
    associatedtype APIType: RESTAPI
    
    associatedtype IdentifierType
    
    associatedtype ModelType: Parseable
    
    static var rootPath: String { get }
    
    var identifier: IdentifierType { get }
}


public final class RESTClient {
    
    public static func getOne<T: RESTResource>(resource: T) -> ProducerPipeline<T.ModelType> {
        
        return RequestBuilder.getOneRequest(resource)
            |> HTTPClient.safeClient()
            |> NSJSONSerialization.deserializeObject
            |> swallowError()
            |> T.ModelType.createWithValues
    }
}

public final class RequestBuilder {
    
    static func getOneRequest<T: RESTResource>(resource: T) -> ThunkProducer<NSURLRequest> {
        
        return ThunkProducer() {
            
            let fullPath = "\(T.APIType.baseURL)/\(T.rootPath)/\(resource.identifier)"
            
            let url = NSURL(string: fullPath)!
            
            return NSURLRequest(URL: url)
        }
    }
}



