//
//  Configuration.swift
//  Rest
//
//  Created by Utsav Patel on 4/7/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import Foundation

class Configuration {
    static let serverUrl  = "https://jsonplaceholder.typicode.com/"
    
    
//    All HTTP verbs are supported.
//    View usage examples.
//    GET     /posts
//    GET     /posts/1
//    GET     /posts/1/comments
//    GET     /comments?postId=1
//    GET     /posts?userId=1
//    POST     /posts
//    PUT     /posts/1
//    PATCH     /posts/1
//    DELETE     /posts/1
    
    enum post: String{
        typealias RawValue = String
        
        case posts
        case comments
        
        var url : String {
            return (Configuration.serverUrl as NSString).appendingPathComponent(self.rawValue)
        }
    }
    
}
