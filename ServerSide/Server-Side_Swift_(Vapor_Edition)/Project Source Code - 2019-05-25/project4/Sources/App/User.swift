//
//  User.swift
//  App
//
//  Created by Paul Hudson on 30/12/2017.
//

import Foundation
import Fluent
import FluentSQLite
import Vapor

struct User: Content, SQLiteModel, Migration {
    var id: Int?
    var username: String
    var password: String
}

