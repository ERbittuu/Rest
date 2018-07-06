
//
//  Endpoint.swift
//  Rest
//
//  Created by Utsav Patel on 4/6/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import Foundation

class Endpoint {
    
    private init() { }
    
    static var shared : WebService {
        let service = WebService()
        Rest.default.showLogs = true
        return service
    }
    
    func simpleGET(with completion: @escaping ((_ data : Data?) -> ())) -> CancellationSource {

//        let source = CancellationSource()
//        //    GET     /posts
//        Rest.prepare(HTTPMethod: .GET, url: Configuration.post.posts.url)
//            .call(cancelToken: source.token) { (data, responce, error) in
//
//        }
//        return source
    }
    
    func simplePOST(with completion: @escaping ((_ data : Data?) -> ())) {
        
//        //    POST     /posts
//       Rest.prepare(HTTPMethod: .POST, url: Configuration.post.posts.url)
//            .call { (data, responce, error) in
//                completion(data)
//                if error == nil {
//                    print(data ?? "No data")
//                }else{
//                    print(error?.localizedDescription ?? "error")
//                }
//        }
    }
}
