//
//  HTTPTransformer.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/15/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import Foundation

public struct HTTPResponse {
    
    let statusCode: Int
    let headers: [String: String]
    let body: NSData?
}

public final class HTTPClient: TransformerType {
    
    static func safeClient() -> TransformerPipeline<NSURLRequest, NSData> {
        
        return HTTPClient()
            |> swallowError()
            |> guardUnwrap { $0.body }
    }
    
    public typealias InputType = NSURLRequest
    
    public typealias OutputType = Result<HTTPResponse>
    
    private let urlSession = NSURLSession.sharedSession()
    
    public var consumer: (OutputType -> Void)?
    
    public func consume(request: NSURLRequest) {
        
        guard let consumer = self.consumer else {
            
            return
        }
        
        let task = urlSession.dataTaskWithRequest(request) { data, urlResponse, error in
            
            if let err = error {
                
                consumer(.Error(err))
                
                return
            }
            
            let httpResponse = urlResponse as! NSHTTPURLResponse
            
            let headers = httpResponse.allHeaderFields as? [String: String] ?? [:]
            
            let response = HTTPResponse(statusCode: httpResponse.statusCode, headers: headers, body: data)
            
            consumer(.Success(response))
        }
        
        task.resume()
    }
}




