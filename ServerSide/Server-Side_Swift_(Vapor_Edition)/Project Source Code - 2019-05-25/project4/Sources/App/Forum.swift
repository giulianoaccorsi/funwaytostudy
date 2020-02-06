//
//  Forum.swift
//  App
//
//  Created by Paul Hudson on 30/12/2017.
//

import Foundation
import Fluent
import FluentSQLite
import Vapor

struct Forum: Content, SQLiteModel, Migration {  
    var id: Int?
    var name: String
}


