//
//  RESTClientTests.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/20/16.
//  Copyright © 2016 arbiter. All rights reserved.
//

import XCTest
import Pipeline

class RESTClientTests: XCTestCase {

    func testGetOne() {
        
        let scienceSub = SubRedditResource(identifier: "science.json")
        
        let getOnePipe = RESTClient.getOne(scienceSub)
        
        let expt = expectationWithDescription("api call")
        
        getOnePipe.consumer = { model in
            
            XCTAssert(model.posts.count > 0)
            
            expt.fulfill()
        }
        
        getOnePipe.produce()
        
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }

}


struct RedditAPI: RESTAPI {
    
    static let baseURL = "http://www.reddit.com"
}

struct SubRedditResource: RESTResource {
    
    typealias APIType = RedditAPI
    
    typealias IdentifierType = String
    
    typealias ModelType = SubReddit
    
    static var rootPath = "r"
    
    let identifier: String
}

struct SubReddit: Parseable {
    
    let posts: [RedditPost]
    
    static func createWithValues(value: [String : AnyObject]) -> SubReddit {
        
        let data = value["data"] as! [String: AnyObject]
        
        let children = data["children"] as! [[String: AnyObject]]
        
        let posts = children.map(RedditPost.createWithValues)
        
        return SubReddit(posts: posts)
    }
}

struct RedditPost: Parseable {
    
    let author: String
    let created: Int
    let ups: Int
    let thumbnailURL: String
    
    static func createWithValues(value: [String : AnyObject]) -> RedditPost {
        
        let data = value["data"] as! [String : AnyObject]
        
        let author = data["author"] as! String
        let created = data["created"] as! Int
        let ups = data["ups"] as! Int
        let thumbnailURL = data["thumbnail"] as! String
        
        return RedditPost(author: author, created: created, ups: ups, thumbnailURL: thumbnailURL)
    }
}

