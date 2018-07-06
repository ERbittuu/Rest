
//
//  Endpoint.swift
//  Rest
//
//  Created by Utsav Patel on 4/6/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import Foundation

public class Endpoint {
    
    private init() { }
    
    public static var shared : Endpoint {
        let service = Endpoint()
        return service
    }
    
    public enum user: String {
        case login
        case register
        case users
        case data
    }
}

extension Endpoint {
    
    // sample response
    //    {
    //    "token": "QpwL5tke4Pnpja7X"
    //    }
    
    //    {
    //    "token": "QpwL5tke4Pnpja7X"
    //    }
    
    /// Login any user with give params
    ///
    /// - parameter email: `String` User email for login
    /// - parameter password: `String` User password for authentication
    /// - parameter completion: The callback called after success or error
    ///
    @discardableResult
    static func login(email: String, password: String,
                      completion: @escaping Handler<UserResponse>) -> CancellationSource {
        
        let cancel = CancellationSource()
        
        Rest.prepare(HTTPMethod: .POST,
                     url: "\(Configuration.serverUrl)\(Endpoint.user.login.rawValue)")
            .setParams(["email": email, "password": password] as [String : Any])
            .call(cancelToken: cancel.token, process: { (response, error) in
                completion(response, error)
            })
        
        return cancel
    }
    
}
