//
//  Info.swift
//  Rest
//
//  Created by Utsav Patel on 7/30/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import Foundation

struct Info: Decodable {
    let id: Int
    let name: String
    let year: Int
    let color: String
    let pantone_value: String
}
