//
//  User.swift
//  Rest
//
//  Created by Utsav Patel on 7/30/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import Foundation

struct User: Decodable {
    let id: Int
    let first_name: String
    let last_name: String
    let avatar: String
}
