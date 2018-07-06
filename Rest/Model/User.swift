//
//  User.swift
//  Rest
//
//  Created by Utsav Patel on 7/6/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import Foundation

struct User: Codable {
    let email: String
    let password: String
}

struct UserResponse: Decodable {
    var token: String?
    var error: String?
    
//    private enum CodingKeys: String, CodingKey {
//        case token, error
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        token = try container.decode(String.self, forKey: .token)
//        error = try container.decode(String.self, forKey: .error)
//    }
    

}

//
//public struct OAuthToken : Decodable
//{
//    let accessToken: String
//    let refreshToken: String
//    let tokenType: String
//    let expiresIn: Int
//    let scope: [String]
//    let additionalData: [String: Any]
//    
//    
//    private enum CodingKeys: String, CodingKey
//    {
//        case accessToken = "access_token"
//        case refreshToken = "refresh_token"
//        case expiresIn = "expires_in"
//        case tokenType = "token_type"
//        case scope
//    }
//    
//    public init(from decoder: Decoder) throws
//    {
//        /
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.accessToken = try container.decode(String.self, forKey: .accessToken)
//        self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
//        self.expiresIn = try container.decode(Int.self, forKey: .expiresIn)
//        self.tokenType = try container.decode(String.self, forKey: .tokenType).capitalized
//        self.expiresOn = Date(timeIntervalSinceNow: TimeInterval(expiresIn))
//        
//        if container.contains(.scope)
//        {
//            self.scope = try container.decode(String.self, forKey: .scope).components(separatedBy: ",")
//        }
//        else
//        {
//            self.scope = []
//        }
//        
//        /
//        let container2 = try decoder.container(keyedBy: AdditionalDataCodingKeys.self)
//        self.additionalData = container2.decodeUnkeyedContainer(exclude: CodingKeys.self)
//    }
//}
//
//private struct AdditionalDataCodingKeys: CodingKey
//{
//    var stringValue: String
//    init?(stringValue: String)
//    {
//        self.stringValue = stringValue
//    }
//    
//    var intValue: Int?
//    init?(intValue: Int)
//    {
//        return nil
//    }
//}
//
//extension KeyedDecodingContainer where Key == AdditionalDataCodingKeys
//{
//    func decodeUnkeyedContainer<T: CodingKey>(exclude keyedBy: T.Type) -> [String: Any]
//    {
//        var data = [String: Any]()
//        
//        for key in allKeys
//        {
//            if keyedBy.init(stringValue: key.stringValue) == nil
//            {
//                if let value = try? decode(String.self, forKey: key)
//                {
//                    data[key.stringValue] = value
//                }
//                else if let value = try? decode(Bool.self, forKey: key) {
//                    data[key.stringValue] = value
//                }
//                else if let value = try? decode(Int.self, forKey: key) {
//                    data[key.stringValue] = value
//                }
//                else if let value = try? decode(Double.self, forKey: key) {
//                    data[key.stringValue] = value
//                }
//                else if let value = try? decode(Float.self, forKey: key) {
//                    data[key.stringValue] = value
//                }
//                else
//                {
//                    NSLog("Key %@ type not supported", key.stringValue)
//                }
//            }
//        }
//        
//        return data
//    }
//}
