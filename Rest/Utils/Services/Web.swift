
//
//  Web.swift
//  Rest
//
//  Created by Utsav Patel on 4/6/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import Foundation

public enum End: String {
    case login
    case register
    case data
    case users
    
    var route: String {
        return "/\(self.rawValue)"
    }
}

struct User: Decodable {
    let id: Int
    let first_name: String
    let last_name: String
    let avatar: String
}

struct Info: Decodable {
    let id: Int
    let name: String
    let year: Int
    let color: String
    let pantone_value: String
}

class Request {
    
    static func login(email: String, password: String, callback: @escaping (_ token: String?, _ error: String?) -> ()) {
        
        struct LoginResponse: Decodable {
            let token: String?
            let error: String?
        }
        
        var option = RestOptions(route: End.login.route, method: .POST)
        option.parameter = [ "email": email, "password": password]
        option.expectedStatusCodes = [400, 200]
        
        Rest.fetchData(with: option) { (result) in

            switch(result) {
                case .success(let data):
                    
                    // decode response with Decodable
                    guard let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                        callback(nil, "Error: Couldn't decode data into LoginResponse")
                        return
                    }
                    if let token = loginResponse.token {
                        callback(token, nil)
                    }else {
                        callback(nil, loginResponse.error!)
                    }
                case .failure(let error):
                    callback(nil, error.localizedDescription)
            }
        }
    }
    
    static func register(email: String, password: String, callback: @escaping (_ token: String?, _ error: String?) -> ()) {

        struct RegisterResponse: Decodable {
            let token: String?
            let error: String?
        }
        
        var option = RestOptions(route: End.register.route, method: .POST)
        option.parameter = [ "email": email, "password": password]
        option.expectedStatusCodes = [400, 201]
        
        Rest.fetchData(with: option) { (result) in
            
            switch(result) {
            case .success(let data):
                // decode response with Decodable
                guard let registerResponse = try? JSONDecoder().decode(RegisterResponse.self, from: data) else {
                    callback(nil, "Error: Couldn't decode data into RegisterResponse")
                    return
                }
                if let token = registerResponse.token {
                    callback(token, nil)
                }else {
                    callback(nil, registerResponse.error!)
                }
            case .failure(let error):
                callback(nil, error.localizedDescription)
            }
        }
    }
    
//    {
//    "page": 2,
//    "per_page": 3,
//    "total": 12,
//    "total_pages": 4,
//    "data": [
//    {
//    "id": 4,
//    "first_name": "Eve",
//    "last_name": "Holt",
//    "avatar": "https://s3.amazonaws.com/uifaces/faces/twitter/marcoramires/128.jpg"
//    },
//    {
//    "id": 5,
//    "first_name": "Charles",
//    "last_name": "Morris",
//    "avatar": "https://s3.amazonaws.com/uifaces/faces/twitter/stephenmoon/128.jpg"
//    },
//    {
//    "id": 6,
//    "first_name": "Tracey",
//    "last_name": "Ramos",
//    "avatar": "https://s3.amazonaws.com/uifaces/faces/twitter/bigmancho/128.jpg"
//    }
//    ]
//    }
//
    static func users(id: Int, isPageId: Bool, callback: @escaping (_ users: [User], _ error: String?) -> ()) {
        
        struct UserListResponse: Decodable {
            let page: Int
            let per_page: Int
            let total: Int
            let total_pages: Int
            let data: [User]
        }
        
        struct UserResponse: Decodable {
            let data: User
        }
        
        var option = RestOptions(route: End.users.route, method: .GET)
        
        if isPageId {
            // users page with page id
            option.parameter = ["page": id]
        } else {
            // user with id
            option.URLParams = [id]
        }
        
        option.expectedStatusCodes = [200, 404]
        
        Rest.fetchData(with: option) { (result) in
            
            switch(result) {
            case .success(let data):
                if isPageId {
                    // decode response with Decodable
                    guard let userListResponse = try? JSONDecoder().decode(UserListResponse.self, from: data) else {
                        callback([], "Error: Couldn't decode data into UserListResponse")
                        return
                    }
                    callback(userListResponse.data, nil)
                } else {
                    // decode response with Decodable
                    guard let userResponse = try? JSONDecoder().decode(UserResponse.self, from: data) else {
                        callback([], "Error: Couldn't decode data into User")
                        return
                    }
                    callback([userResponse.data], nil)
                }
            case .failure(let error):
                callback([], error.localizedDescription)
            }
        }
    }
    
    static func info(id: Int, isPageId: Bool, callback: @escaping (_ users: [Info], _ error: String?) -> ()) {
        
        struct InfoListResponse: Decodable {
            let page: Int
            let per_page: Int
            let total: Int
            let total_pages: Int
            let data: [Info]
        }
        
        struct InfoResponse: Decodable {
            let data: Info
        }
        
        var option = RestOptions(route: End.data.route, method: .GET)
        
        if isPageId {
            // users page with page id
            option.parameter = ["page": id]
        } else {
            // user with id
            option.URLParams = [id]
        }
        
        option.expectedStatusCodes = [200, 404]
        
        Rest.fetchData(with: option) { (result) in
            
            switch(result) {
            case .success(let data):
                if isPageId {
                    // decode response with Decodable
                    guard let userListResponse = try? JSONDecoder().decode(InfoListResponse.self, from: data) else {
                        callback([], "Error: Couldn't decode data into InfoListResponse")
                        return
                    }
                    callback(userListResponse.data, nil)
                } else {
                    // decode response with Decodable
                    guard let infoResponse = try? JSONDecoder().decode(InfoResponse.self, from: data) else {
                        callback([], "Error: Couldn't decode data into Info")
                        return
                    }
                    callback([infoResponse.data], nil)
                }
                
            case .failure(let error):
                callback([], error.localizedDescription)
            }
        }
    }
    
}
 
// login post success
// login post un success
//
// register success
// register un success
//
// delay response by some time
//
// data list
// data by id found
// data by id not found
//
// users list
// user by id found
// user by id not found
//
// user create
// user update
// user delete
//
// */
