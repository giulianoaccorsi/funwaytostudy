//
//  User.swift
//  App
//
//  Created by Paul Hudson on 30/12/2017.
//

import Authentication
import Fluent
import FluentSQLite
import Foundation
import Vapor

struct User: Content, SQLiteModel, Migration {
    var id: Int?
    var username: String
    var password: String
    var language: String
}

extension User: BasicAuthenticatable {
    static let usernameKey = \User.username
    static let passwordKey = \User.password
}

