
//
//  Web.swift
//  Rest
//
//  Created by Utsav Patel on 4/6/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import Foundation

class Web {
    
    static func defaultSettings() {
        Rest.default.origin = AppDelegate.configuration.environment.rootURL
        Rest.default.showLogs = true
        Rest.default.activityIndicatorDisplay = true
    }
    
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
 
    static func updateUser(info: (name : String, job: String), id: Int, callback: @escaping (_ success: Bool, _ error: String?) -> ()) {
        
        struct UpdateResponse: Decodable {
            let name: String
            let job: String
            let updatedAt: String
        }
        
        var option = RestOptions(route: End.users.route, method: .PUT)
        
        // user with id
        option.URLParams = [id]
        
        // update data
        option.parameter = ["name": info.name, "job": info.job]
        
        option.expectedStatusCodes = [200, 404]
        
        Rest.fetchData(with: option) { (result) in
            
            switch(result) {
            case .success(let data):
                // decode response with Decodable
                guard let userListResponse = try? JSONDecoder().decode(UpdateResponse.self, from: data) else {
                    callback(false, "Error: Couldn't decode data into UpdateResponse")
                    return
                }
                print("data successfully updatedAt \(userListResponse.updatedAt)")
                callback(true, nil)
            case .failure(let error):
                callback(false, error.localizedDescription)
            }
        }
    }
    
    static func deleteUser(id: Int, callback: @escaping (_ success: Bool, _ error: String?) -> ()) {
  
        var option = RestOptions(route: End.users.route, method: .DELETE)
        
        // user with id
        option.URLParams = [id]
        
        option.expectedStatusCodes = [204]
        
        Rest.fetchData(with: option) { (result) in
            
            switch(result) {
            case .success(_):
                print("user successfully deleted")
                callback(true, nil)
            case .failure(let error):
                callback(false, error.localizedDescription)
            }
        }
    }
    
    static func delayCall(callback: @escaping (_ success: Bool, _ error: String?) -> ()) ->  CancellationSource {
        
        let cancellationSource = CancellationSource()
        
        var option = RestOptions(route: End.users.route, method: .GET)
        
        // user with id
        option.URLParams = [2]
        option.parameter = ["delay": 10]
        
        option.expectedStatusCodes = [200, 404]
        
        Rest.fetchData(with: option, andCancelToken: cancellationSource.token) { (result) in
            
            switch(result) {
            case .success(_):
                print("user successfully deleted")
                callback(true, nil)
            case .failure(let error):
                callback(false, error.localizedDescription)
            }
        }
        
        return cancellationSource
    }
}
