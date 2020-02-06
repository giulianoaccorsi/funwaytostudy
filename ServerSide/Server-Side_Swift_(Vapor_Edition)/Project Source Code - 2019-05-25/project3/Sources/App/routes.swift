import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.get("hello", "world") { req in
        return "Hello, world!"
    }
    
    router.get("greetings", String.parameter) { req -> String in
        let name = try req.parameters.next(String.self)
        return "Greetings, \(name)!"
    }
    
    router.get("read", Int.parameter) { req -> String in
        let number = try req.parameters.next(Int.self)
        return "Chapter \(number)…"
    }
    
    router.get("posts", Int.parameter, String.parameter) { req -> String in
        let id = try req.parameters.next(Int.self)
        let title = try req.parameters.next(String.self)
        return "Loading article \(id) with title \(title)."
    }
    
    router.get("articles", Article.parameter) { req -> String in
        let article = try req.parameters.next(Article.self)
        return "Loading article: \(article.title)"
    }
    
    router.get("articles", Article.parameter, "json") { req -> Article in
        return try req.parameters.next(Article.self)
    }
    
    router.group("hello") { group in
        group.get("world") { req in
            return "Hello, world!"
        }
        
        group.get("kitty") { req in
            return "Hello Kitty"
        }
    }
    
    router.group("article", Int.parameter) { group in
        group.get("read") { req -> String in
            let num = try req.parameters.next(Int.self)
            return "Reading article \(num)"
        }
        
        group.get("edit") { req -> String in
            let num = try req.parameters.next(Int.self)
            return "Editing article \(num)"
        }
    }
    
    let article = router.grouped("article", Int.parameter)
    
    article.get("read") { req -> String in
        let num = try req.parameters.next(Int.self)
        return "Reading article \(num)"
    }
    
    article.get("edit") { req -> String in
        let num = try req.parameters.next(Int.self)
        return "Editing article \(num)"
    }
    
    try router.grouped("admin").register(collection: AdminCollection())
}

struct Article: Parameter, Content {
    var id: Int
    var title: String
    
    init(id: Int) {
        self.id = id
        self.title = "Custom parameters rock!"
    }
    
    static func resolveParameter(_ parameter: String, on container: Container) throws -> Article {
        if let id = Int(parameter) {
            // the conversion worked – return an Article
            return Article(id: id)
        } else {
            // the conversion failed – throw an error
            throw Abort(.badRequest)
        }
    }
}

final class AdminCollection: RouteCollection {
    func boot(router: Router) throws {
        let article = router.grouped("article", Int.parameter)
        
        article.get("read") { req -> String in
            let num = try req.parameters.next(Int.self)
            return "Reading article \(num)"
        }
        
        article.get("edit") { req -> String in
            let num = try req.parameters.next(Int.self)
            return "Editing article \(num)"
        }
    }
}
