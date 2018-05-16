//
//  Users.swift
//  SwiftInstagram
//
//  Created by Ander Goig on 29/10/17.
//  Copyright © 2017 Ander Goig. All rights reserved.
//

import UIKit

extension Instagram {

    // MARK: - User Endpoints

    /// Get information about a user.
    ///
    /// - parameter userId: The ID of the user whose information to retrieve, or "self" to reference the currently authenticated user.
    /// - parameter success: The callback called after a correct retrieval.
    /// - parameter failure: The callback called after an incorrect retrieval.
    ///
    /// - important: It requires *public_content* scope when getting information about a user other than yours.
    public func user(_ userId: String, success: SuccessHandler<InstagramUser>?, failure: FailureHandler?) {
        request("/users/\(userId)", success: { data in success?(data!) }, failure: failure)
    }

    /// Get a list of users matching the query.
    ///
    /// - parameter query: A query string.
    /// - parameter count: Number of users to return.
    /// - parameter success: The callback called after a correct retrieval.
    /// - parameter failure: The callback called after an incorrect retrieval.
    ///
    /// - important: It requires *public_content* scope.
    public func search(user query: String, count: Int? = nil, success: SuccessHandler<[InstagramUser]>?, failure: FailureHandler?) {
        var parameters = Parameters()

        parameters["q"] = query
        parameters["count"] ??= count

        request("/users/search", parameters: parameters, success: { data in success?(data!) }, failure: failure)
    }
}
