import FluentSQLite
import Vapor

final class Acronym: Codable {
    var id: Int?
    var short: String
    var long: String
    
    init(id: Int, short: String, long: String) {
        self.id = id
        self.short = short
        self.long = long
    }
}

extension Acronym: SQLiteModel { }
extension Acronym: Migration { }
extension Acronym: Content { }


