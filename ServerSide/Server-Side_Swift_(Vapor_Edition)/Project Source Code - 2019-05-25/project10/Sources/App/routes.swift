import Authentication
import Crypto
import Fluent
import FluentSQLite
import Foundation
import Leaf
import Routing
import Vapor

struct ProjectList: Codable {
    var projects: [Project]
    var activePage: String
}

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    router.get("setup") { req -> String in
        let password = try BCrypt.hash("password")
        let item1 = User(id: 1, username: "twostraws", password: password, language: "Swift")
        let item2 = User(id: 2, username: "taylor", password: password, language: "Swift")
        
        _ = item1.create(on: req)
        _ = item2.create(on: req)
        
        return "OK"
    }
    
    router.get { req -> Future<View> in
        return try req.view().render("home")
    }
    
    router.get("login") { req -> Future<View> in
        return try req.view().render("login")
    }

    router.post("login") { req -> Future<AnyResponse> in
        // pull out the two login fields
        let username: String = try req.content.syncGet(at: "username")
        let password: String = try req.content.syncGet(at: "password")
        
        // convert them to a password struct
        let authenticationPassword = BasicAuthorization(username: username, password: password)

        // attempt to find those credentials in our database
        return User.authenticate(using: authenticationPassword, verifier: BCryptDigest(), on: req).map(to: AnyResponse.self) { user in
            if let user = user {
                // they were found! Save their data in their session
                let session = try req.session()
                session["user_id"] = String(user.id!)
                session["username"] = user.username
                
                // now redirect to /projects/mine (we haven't made this yet!)
                let redirect = req.redirect(to: "/projects/mine")
                return AnyResponse(redirect)
            } else {
                // user wasn't found - re-render the login page
                let context = ["error": true]
                let page = try req.view().render("login", context)
                return AnyResponse(page)
            }
        }
    }
    
    router.get("/projects/mine") { req -> Future<View> in
        // make sure we have an authenticated user
        let session = try req.session()
        guard let userID = session["user_id"] else {
            throw Abort(.unauthorized)
        }
        
        // find all projects owned by this user
        return Project.query(on: req)
            .filter(\.owner == Int(userID) ?? 0)
            .all().flatMap(to: View.self) { projects in
                // render them to a Leaf template
                let context = ProjectList(projects: projects, activePage: "page_projects_mine")
                return try req.view().render("projects_mine", context)
        }
    }
    
    router.get("projects", "delete", Int.parameter) { req -> Future<Response> in
        let session = try req.session()
        guard let userID = session["user_id"] else {
            throw Abort(.unauthorized)
        }
        
        let id = try req.parameters.next(Int.self)
        
        return Project.query(on: req)
            .filter(\.id == id)
            .filter(\.owner == Int(userID) ?? 0)
            .delete().map(to: Response.self) {
                return req.redirect(to: "/projects/mine")
        }
    }
    
    router.get("projects", "new") { req -> Future<View> in
        let session = try req.session()
        guard session["user_id"] != nil else {
            throw Abort(.unauthorized)
        }
        
        return try req.view().render("projects_new", ["activePage": "page_projects_new"])
    }
    
    router.post("projects", "new") { req -> Future<Response> in
        // 1: check we have a fully authenticated user
        let session = try req.session()
        guard let userID = session["user_id"] else {
            throw Abort(.unauthorized)
        }
        
        // 2: pull out the form fields we need
        let name: String = try req.content.syncGet(at: "name")
        let description: String = try req.content.syncGet(at: "description")
        let language: String = try req.content.syncGet(at: "language")
        
        // 3: convert the fields into a Project instance
        let project = Project(id: nil, owner: Int(userID) ?? 0, name: name, language: language, description: description, date: Date())
        
        // 4: save the project
        return project.save(on: req).map(to: Response.self) { project in
            // 5: send them back to /projects/mine
            return req.redirect(to: "/projects/mine")
        }
    }
    
    router.get("projects", "all") { req -> Future<View> in
        let session = try req.session()
        guard session["user_id"] != nil else {
            throw Abort(.unauthorized)
        }
        
        return Project.query(on: req)
            .all().flatMap(to: View.self) { projects in
                let context = ProjectList(projects: projects, activePage: "page_projects_all")
                return try req.view().render("projects_all", context)
        }
    }
    
    router.get("projects", "search") { req -> Future<View> in
        struct ProjectSearch: Codable {
            var projects: [Project]
            var users: [User]
            var activePage: String
        }
        
        let session = try req.session()
        guard session["user_id"] != nil else {
            throw Abort(.unauthorized)
        }
        
        if let language: String = try req.query.get(at: "language") {
            return Project.query(on: req).filter(\.language == language).all().flatMap(to: View.self) { projects in
                return User.query(on: req).filter(\.language == language).all().flatMap(to: View.self) { users in
                    let context = ProjectSearch(projects: projects, users: users, activePage: "page_projects_search")
                    return try req.view().render("projects_search", context)
                }
            }
        } else {
            let context = ProjectSearch(projects: [], users: [], activePage: "page_projects_search")
            return try req.view().render("projects_search", context)
        }
    }
}
