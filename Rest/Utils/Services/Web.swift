
//
//  Web.swift
//  Rest
//
//  Created by Utsav Patel on 4/6/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import Foundation

class Web {
    
    private init() { }
    
    static var shared : Web {
        let service = Web()
        Rest.default.showLogs = true
        return service
    }
    
    func fetch<T: Decodable>(end: End,_ callback: @escaping Handler<T>) {
//        
//        switch end {
//        case .user(id: let userid):
//            
//            print(userid ?? "")
//            
//        case .login(let username, let password):
////            
////            Rest.prepare(HTTPMethod: .POST, url: end.point)
////                .setParams(["email": "peter@klaven", "password": "cityslicka"])
////                .call { (decode, error) in
////                    callback(decode, error)
////            }
//            //            Rest.prepare(HTTPMethod: .GET, url: Instagram.API.baseURL)
//            //                .setURLParams(["users", userId, "media", "recent"])
//            //                .setParams(["access_token": Instagram.shared.retrieveAccessToken() ?? ""])
//            //                .call { (decode, error) in
//            //                    success(decode, error)
//            //            }
//            
//        default:
//            return
//        }
//        
    }
////
////    func simpleGET(with completion: @escaping ((_ data : Data?) -> ())) -> CancellationSource {
////
////        let source = CancellationSource()
////        //    GET     /posts
////        Rest.prepare(HTTPMethod: .GET, url: Configuration.post.posts.url)
////            .call(cancelToken: source.token) { (data, responce, error) in
////
////        }
////        return source
////    }
////
////    func simplePOST(with completion: @escaping ((_ data : Data?) -> ())) {
////
////        //    POST     /posts
////       Rest.prepare(HTTPMethod: .POST, url: Configuration.post.posts.url)
////            .call { (data, responce, error) in
////                completion(data)
////                if error == nil {
////                    print(data ?? "No data")
////                }else{
////                    print(error?.localizedDescription ?? "error")
////                }
////        }
////    }
}


public enum End {
    case login(username: String, password: String)
    case register(username: String, password: String)
    case data(id: String?)
    case user(id: String?)
    
    var point: String {
        switch self {
        case .login(username: _, password: _):
            return "/login"
        case .register(username: _, password: _):
            return "/register"
        case .data(id: _):
            return "/unknown"
        case .user(id: _):
            return "/users"
        }
    }
    
 
//    public static func user(fromUser userId: String,
//                                   nextUrl: String? = nil,
//                                   success: @escaping Handler<PhotoResponse>) {
//
//        print(nextUrl ?? "sa")
//        if let nextUrl = nextUrl {
//            Rest.prepare(HTTPMethod: .GET, url: nextUrl)
//                .call { (decode, error) in
//                    success(decode, error)
//            }
//        }else{
//            Rest.prepare(HTTPMethod: .GET, url: Instagram.API.baseURL)
//                .setURLParams(["users", userId, "media", "recent"])
//                .setParams(["access_token": Instagram.shared.retrieveAccessToken() ?? ""])
//                .call { (decode, error) in
//                    success(decode, error)
//            }
//        }
//
//    }
}



/*

/// Get the most recent media published by a user.
///
/// - parameter userId: The ID of the user whose recent media to retrieve, or "self" to reference the currently authenticated user.
/// - parameter success: The callback called after a correct retrieval.
/// - parameter failure: The callback called after an incorrect retrieval.
///
/// - important: It requires *public_content* scope when getting recent media published by a user other than yours.
public static func recentMedia(fromUser userId: String,
                               nextUrl: String? = nil,
                               success: @escaping Handler<PhotoResponse>) {
    
    print(nextUrl ?? "sa")
    if let nextUrl = nextUrl {
        Rest.prepare(HTTPMethod: .GET, url: nextUrl)
            .call { (decode, error) in
                success(decode, error)
        }
    }else{
        Rest.prepare(HTTPMethod: .GET, url: Instagram.API.baseURL)
            .setURLParams(["users", userId, "media", "recent"])
            .setParams(["access_token": Instagram.shared.retrieveAccessToken() ?? ""])
            .call { (decode, error) in
                success(decode, error)
        }
    }
    
}
 
 login post success
 login post un success
 
 register success
 register un success
 
 delay response by some time
 
 data list
 data by id found
 data by id not found
 
 users list
 user by id found
 user by id not found
 
 user create
 user update
 user delete
 
 */
