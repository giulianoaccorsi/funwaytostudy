//
//  Project.swift
//  App
//
//  Created by Paul Hudson on 30/12/2017.
//

import Authentication
import Foundation
import FluentSQLite
import Vapor

struct Project: Content, SQLiteModel, Migration {  
    var id: Int?
    var owner: Int
    var name: String
    var language: String
    var description: String
    var date: Date
}

