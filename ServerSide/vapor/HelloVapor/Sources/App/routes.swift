import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.get("hello", "vapor") { (req) in
        return "hello Vapor"
    }
    
    router.get("hello", String.parameter) { req -> String in
        let name = try req.parameters.next(String.self)
        return "Hellouuuu \(name)"
    }
    
    router.post("info") { (req) -> String in
        let data = try req.content.syncDecode(InfoData.self)
        return "Hello: \(data.name)"
    }
    
    router.post("infoData") { (req) -> InfoReponse in
          let data = try req.content.syncDecode(InfoData.self)
          return InfoReponse(request: data)
      }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}

struct InfoData: Content {
    let name: String
}

struct InfoReponse: Content {
    let request: InfoData
}
