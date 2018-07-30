//
//  Configuration.swift
//  Rest
//
//  Created by Utsav Patel on 4/7/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import Foundation

struct Configuration {
    lazy var environment: Environment = {
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
            if configuration.range(of: "Dev") != nil {
                return Environment.Development
            } else if configuration.range(of: "Stage") != nil {
                return Environment.Staging
            }
        }
        return Environment.Production
    }()
}

// End Points
public enum End: String {
    case login
    case register
    case data
    case users
    
    var route: String {
        return "/\(self.rawValue)"
    }
}
