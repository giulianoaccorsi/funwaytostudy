//
//  Message.swift
//  App
//
//  Created by Paul Hudson on 30/12/2017.
//

import Foundation
import Fluent
import FluentSQLite
import Vapor

struct Message: Content, SQLiteModel, Migration {  
    var id: Int?
    var forum: Int
    var title: String
    var body: String
    var parent: Int
    var user: String
    var date: Date
}

