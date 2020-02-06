//
//  Post.swift
//  App
//
//  Created by Paul Hudson on 30/12/2017.
//

import Foundation
import FluentMySQL
import Vapor

struct Post: Content, MySQLModel, Migration {
    var id: Int?
    var title: String
    var strap: String
    var content: String
    var category: Int
    var slug: String
    var date: Date
    
    static func prepare(on connection: MySQLConnection) -> Future<Void> {
        return MySQLDatabase.create(self, on: connection) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.title)
            builder.field(for: \.strap)
            builder.field(for: \.content, type: .text())
            builder.field(for: \.category)
            builder.field(for: \.slug)
            builder.field(for: \.date)
        }
    }
}
