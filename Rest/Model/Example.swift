//
//  Example.swift
//  Rest
//
//  Created by Utsav Patel on 4/6/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import Foundation

struct Example {
    let httpMethod: String
    let description: String
    
    init(httpMethod: String, description: String) {
        self.httpMethod = httpMethod
        self.description = description
    }
    
    static func list() -> [Example] {
        return [
            Example(httpMethod: "GET", description: "GET details"),
            Example(httpMethod: "POST", description: "POST details"),
            Example(httpMethod: "PUT", description: "PUT details"),
            Example(httpMethod: "DELETE", description: "DELETE details"),
            Example(httpMethod: "PATCH", description: "PATCH details"),
            Example(httpMethod: "HEAD", description: "HEAD details"),
            Example(httpMethod: "OPTIONS", description: "OPTIONS details")
        ]
    }
}
