import Vapor
import Foundation

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    router.get("date") { req -> String in
        let dia = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale(identifier: "pt_br")
        let diaFormatado = dateFormatter.string(from: dia)
        return "Hoje é dia: \(diaFormatado)"
    }
    
//    router.get("counter", String.parameter) { (req) -> String in
//        let numbers = try req.content.decode(Int.self)
//        return ""
//    }
    
    router.post("user-info") { (req) -> String in
        let data = try req.content.syncDecode(UserInfo.self)
        return "Hello \(data.name), you are \(data.age)"
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}

struct UserInfo: Content {
    var name: String
    var age: Int
}

struct UserResponse: Content {
    var request: UserInfo
}
