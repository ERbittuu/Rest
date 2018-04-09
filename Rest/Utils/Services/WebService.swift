
//
//  WebService.swift
//  Rest
//
//  Created by Utsav Patel on 4/6/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import Foundation

class WebService {
    
    private init() { }
    
    static let shared = WebService()
    
    func simpleGET() {

        //    GET     /posts/1/comments
        Rest.prepare(HTTPMethod: .GET, url: Configuration.serverUrl)
            .setURLParams(["posts", "1", "comments"])
            .call { (data, responce, error) in
                if error == nil {
                    print(data ?? "No data")
                }else{
                    print(error?.localizedDescription ?? "error")
                }
        }
        
        //    GET     /posts
//        Rest.prepare(HTTPMethod: .GET, url: Configuration.post.posts.url)
//            .call { (data, responce, error) in
//                if error == nil {
//                    print(data ?? "No data")
//                }else{
//                    print(error?.localizedDescription ?? "error")
//                }
//        }
        
        //    GET     /comments?postId=1
//        Rest.prepare(HTTPMethod: .GET, url: Configuration.post.posts.url)
//            .setParams(["userId" : 1])
//            .call { (data, responce, error) in
//                if error == nil {
//                    print(data ?? "No data")
//                }else{
//                    print(error?.localizedDescription ?? "error")
//                }
//        }
    }
    
    func SimplePOST() {
        
        //    POST     /posts
                Rest.prepare(HTTPMethod: .POST, url: Configuration.post.posts.url)
                    .call { (data, responce, error) in
                        if error == nil {
                            print(data ?? "No data")
                        }else{
                            print(error?.localizedDescription ?? "error")
                        }
                }
    }
    
    func SimplePUT() {
        
        //    PUT     /posts/1
        Rest.prepare(HTTPMethod: .PUT, url: Configuration.serverUrl)
            .setURLParams(["posts", "1"])
            .call { (data, responce, error) in
                if error == nil {
                    print(data ?? "No data")
                }else{
                    print(error?.localizedDescription ?? "error")
                }
        }
    }
    
    func SimplePATCH() {
        
        //    PATCH     /posts/1
        Rest.prepare(HTTPMethod: .PATCH, url: Configuration.serverUrl)
            .setURLParams(["posts", "1"])
            .call { (data, responce, error) in
                if error == nil {
                    print(data ?? "No data")
                }else{
                    print(error?.localizedDescription ?? "error")
                }
        }
    }
    
    func SimpleDELETE() {
        
        //    DELETE     /posts/1
        Rest.prepare(HTTPMethod: .DELETE, url: Configuration.serverUrl)
            .setURLParams(["posts", "1"])
            .call { (data, responce, error) in
                if error == nil {
                    print(data ?? "No data")
                }else{
                    print(error?.localizedDescription ?? "error")
                }
        }
    }
    
    func SimpleTRY() {
        print("Try Yourself")
    }
    
}
