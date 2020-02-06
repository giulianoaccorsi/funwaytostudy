import Leaf
import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    router.get("hello") { req -> Future<View> in
        struct ExampleData: Codable {
            let haters = "hating"
            let names = ["Taylor", "Paul", "Justin", "Adele"]
            let results = ["Scott": 90, "Dan": 85, "Liz": 100]
            let quote = "He thrusts his fists against the posts and still insists he sees the ghosts"
        }
        
        return try req.view().render("home", ExampleData())
    }
}
