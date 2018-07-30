//
//  Environment.swift
//  Rest
//
//  Created by Utsav Patel on 7/30/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import Foundation

enum Environment: String {
    case Development = "Development"
    case Staging = "Staging"
    case Production = "Production"
    
    var name: String {
       return self.rawValue
    }

    var info: String {
        let infoDictionary = Bundle.main.infoDictionary!
        return "\(name): [\(Bundle.main.bundleIdentifier!) v\(infoDictionary["CFBundleShortVersionString"] ?? "0")(\(infoDictionary["CFBundleVersion"] ?? "0"))] Running....\n"
    }
    
    static var version =  "" // "v5/" //"v4/" // "v3/" // "v2/" // "v1" // ""
        
    var rootURL: String {
        return rootOrigin + Environment.version
    }
    
    private var rootOrigin: String {
        switch self {
            case .Development:
                return "https://reqres.in/api"
            case .Staging:
                return "https://reqres.in/api"
            case .Production:
                return "https://reqres.in/api"
        }
    }
    
   // google map keys
   // instagram Keys keys
}
