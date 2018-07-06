//
//  Configuration.swift
//  Rest
//
//  Created by Utsav Patel on 4/7/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import Foundation

class Configuration {
    
    static let serverUrl  = "http://localhost:5000/api/"
    
    enum post: String{
        typealias RawValue = String
        
        case posts
        case comments
        
        var url : String {
            return (Configuration.serverUrl as NSString).appendingPathComponent(self.rawValue)
        }
    }
    
}
