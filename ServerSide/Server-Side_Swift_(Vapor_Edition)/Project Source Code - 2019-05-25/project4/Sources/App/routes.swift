import Crypto
import Fluent
import FluentSQLite
import Foundation
import Leaf
import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.get("setup") { req -> String in
//            let item1 = Forum(id: 1, name: "Taylor's Songs")
//            let item2 = Forum(id: 2, name: "Taylor's Albums")
//            let item3 = Forum(id: 3, name: "Taylor's Concerts")
        
        let item1 = Message(id: 1, forum: 1, title: "Welcome", body: "Hello!", parent: 0, user: "twostraws", date: Date())
        let item2 = Message(id: 2, forum: 1, title: "Second post", body: "Hello!", parent: 0, user: "twostraws", date: Date())
        let item3 = Message(id: 3, forum: 1, title: "Test reply", body: "Yay!", parent: 1, user: "twostraws", date: Date())
        
        _ = item1.create(on: req)
        _ = item2.create(on: req)
        _ = item3.create(on: req)
        
        return "OK"
    }

    router.get { req -> Future<View> in
        struct HomeContext: Codable {
            var username: String?
            var forums: [Forum]
        }
        
        return Forum.query(on: req).all().flatMap(to: View.self) { forums in
            let context = HomeContext(username: getUsername(req), forums: forums)
            return try req.view().render("home", context)
        }
    }
    
    router.get("forum", Int.parameter) { req -> Future<View> in
        struct ForumContext: Codable {
            var username: String?
            var forum: Forum
            var messages: [Message]
        }
        
        // pull out the forum ID they requested
        let forumID = try req.parameters.next(Int.self)
        
        // look for it in our database
        return Forum.find(forumID, on: req).flatMap(to: View.self) { forum in
            guard let forum = forum else {
                // that forum doesn't exist – bail out!
                throw Abort(.notFound)
            }
            
            // find all top-level messages that belong to this forum
            let query = Message.query(on: req)
                .filter(\.forum == forum.id!)
                .filter(\.parent == 0)
                .all()
            
            // convert all our data into a Leaf view
            return query.flatMap(to: View.self) { messages in
                let context = ForumContext(username: getUsername(req), forum: forum, messages: messages)
                return try req.view().render("forum", context)
            }
        }
    }
    
    router.get("forum", Int.parameter, Int.parameter) { req -> Future<View> in
        // prepare a context struct we can pass to Leaf
        struct MessageContext: Codable {
            var username: String?
            var forum: Forum
            var message: Message
            var replies: [Message]
        }
        
        // pull out the IDs for our forum and message
        let forumID = try req.parameters.next(Int.self)
        let messageID = try req.parameters.next(Int.self)
        
        // look up the forum that was requested
        return Forum.find(forumID, on: req).flatMap(to: View.self) { forum in
            guard let forum = forum else {
                // the forum doesn't exist - bail out!
                throw Abort(.notFound)
            }
            
            // now look up the message that was requested
            return Message.find(messageID, on: req).flatMap(to: View.self) { message in
                guard let message = message else {
                    // the message doesn't exist - bail out!
                    throw Abort(.notFound)
                }
                
                // finally, find all replies to this message
                let query = Message.query(on: req)
                    .filter(\.parent == message.id!)
                    .all()
                
                // convert those replies – and all previous data – into our Leaf view
                return query.flatMap(to: View.self) { replies in
                    let context = MessageContext(username: getUsername(req), forum: forum, message: message, replies: replies)
                    return try req.view().render("message", context)
                }
            }
        }
    }
    
    router.get("users", "create") { req -> Future<View> in
        return try req.view().render("users-create")
    }
    
    router.post("users", "create") { req -> Future<View> in
        var user = try req.content.syncDecode(User.self)
        
        return User.query(on: req)
            .filter(\.username == user.username)
            .first().flatMap(to: View.self) { existing in
                if existing == nil {
                    user.password = try BCrypt.hash(user.password)
                    
                    return user.save(on: req).flatMap(to: View.self) { user in
                        return try req.view().render("users-welcome")
                    }
                } else {
                    let context = ["error": "true"]
                    return try req.view().render("users-create", context)
                }
        }
    }
    
    router.get("users", "login") { req -> Future<View> in
        return try req.view().render("users-login")
    }
    
    router.post(User.self, at: "users", "login") { req, user -> Future<View> in        
        return User.query(on: req)
            .filter(\.username == user.username)
            .first().flatMap(to: View.self) { existing in
                if let existing = existing {
                    if try BCrypt.verify(user.password, created: existing.password) {
                        let session = try req.session()
                        session["username"] = existing.username
                        return try req.view().render("users-welcome")
                    }
                }
                
                let context = ["error": "true"]
                return try req.view().render("users-login", context)
        }
    }
    
    router.post("forum", Int.parameter, use: postOrReply)
    router.post("forum", Int.parameter, Int.parameter, use: postOrReply)
}
    
func postOrReply(req: Request) throws -> Future<Response> {
    guard let username = getUsername(req) else {
        throw Abort(.unauthorized)
    }
    
    let forumID = try req.parameters.next(Int.self)
    let parentID = (try? req.parameters.next(Int.self)) ?? 0
    let title: String = try req.content.syncGet(at: "title")
    let body: String = try req.content.syncGet(at: "body")
    
    let post = Message(id: nil, forum: forumID, title: title, body: body, parent: parentID, user: username, date: Date())
    return post.save(on: req).map(to: Response.self) { post in
        if parentID == 0 {
            return req.redirect(to: "/forum/\(forumID)/\(post.id!)")
        } else {
            return req.redirect(to: "/forum/\(forumID)/\(parentID)")
        }
    }
}

func getUsername(_ req: Request) -> String? {
    let session = try? req.session()
    return session?["username"]
}
