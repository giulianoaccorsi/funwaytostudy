//
//  Category.swift
//  App
//
//  Created by Paul Hudson on 30/12/2017.
//

import Foundation
import FluentMySQL
import Vapor

struct Category: Content, MySQLModel, Migration {
    var id: Int?
    var name: String
}


