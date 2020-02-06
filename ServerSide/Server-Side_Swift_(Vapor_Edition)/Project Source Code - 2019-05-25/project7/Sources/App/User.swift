//
//  User.swift
//  App
//
//  Created by Paul Hudson on 30/12/2017.
//

import Foundation
import FluentSQLite
import Vapor

struct User: Content, SQLiteStringModel, Migration {
    var id: String?
    var password: String
}

