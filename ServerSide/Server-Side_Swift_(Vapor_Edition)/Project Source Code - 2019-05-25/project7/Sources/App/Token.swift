//
//  Token.swift
//  App
//
//  Created by Paul Hudson on 30/12/2017.
//

import Foundation
import FluentSQLite
import Vapor

struct Token: Content, SQLiteUUIDModel, Migration {
    var id: UUID?
    var username: String
    var expiry: Date
}
