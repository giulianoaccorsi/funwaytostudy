//
//  FrontEnd.swift
//  App
//
//  Created by Paul Hudson on 30/12/2017.
//

import Foundation
import Leaf
import Markdown
import SwiftSlug
import Vapor

struct CategoryPage: Codable {
    var title: String
    var stories: [Post]
    var categories: [Category]
}

struct StoryPage: Codable {
    var title: String
    var story: Post
    var categories: [Category]
}

class FrontEnd: RouteCollection {
    var categories = [Category]()

    func boot(router: Router) throws {
        router.get(use: getHomePage)
        router.get("read", Int.parameter, String.parameter, use: getStory)

        router.group("admin") { group in
            group.get(use: self.getAdminHome)

            group.get("edit", Int.parameter, use: self.getAdminEdit)
            group.get("edit", use: self.getAdminEdit)

            group.post("edit", Int.parameter, use: self.postAdminEdit)
            group.post("edit", use: self.postAdminEdit)
        }
    }

    func getHomePage(req: Request) throws -> Future<View> {
        return try req.client().get("http://localhost:8080/backend/stories").flatMap(to: View.self) { response in
            let posts = try response.content.syncDecode([Post].self)
            let categories = try self.getCategories(for: req)

            return categories.flatMap(to: View.self) { categories in
                let context = CategoryPage(title: "Top Stories", stories: posts, categories: categories)
                return try req.view().render("home", context)
            }
        }
    }

    func getStory(req: Request) throws -> Future<View> {
        guard let id = try? req.parameters.next(Int.self) else {
            return try req.view().render("error")
        }

        let uri = "http://localhost:8080/backend/story/\(id)"

        return try req.client().get(uri).flatMap(to: View.self) { response in
            if let post = try? response.content.syncDecode(Post.self) {
                return try self.getCategories(for: req).flatMap(to: View.self) { categories in
                    let context = StoryPage(title: post.title, story: post, categories: categories)
                    return try req.view().render("read", context)
                }
            } else {
                return try req.view().render("error")
            }
        }
    }

    func getAdminHome(req: Request) throws -> Future<View> {
        return try req.client().get("http://localhost:8080/backend/stories").flatMap(to: View.self) { response in
            let posts = try response.content.syncDecode([Post].self)
            let categories = try self.getCategories(for: req)

            return categories.flatMap(to: View.self) { categories in
                let context = CategoryPage(title: "Admin", stories: posts, categories: categories)
                return try req.view().render("admin_home", context)
            }
        }
    }

    func getAdminEdit(req: Request) throws -> Future<View> {
        // if an article ID was passed to us
        if let id = try? req.parameters.next(Int.self) {
            // fetch the associated story
            let uri = "http://localhost:8080/backend/story/\(id)"

            return try req.client().get(uri).flatMap(to: View.self) { response in
                // convert it into a Post object for our context
                let post = try response.content.syncDecode(Post.self)
                let categories = try self.getCategories(for: req)

                return categories.flatMap(to: View.self) { categories in
                    let context = StoryPage(title: "Article Edit", story: post, categories: categories)

                    // then render the editing template
                    return try req.view().render("admin_edit", context)
                }
            }
        } else {
            // no article ID; just render the editing template with a blank post
            let empty = Post(id: nil, title: "", strap: "", content: "", category: 1, slug: "", date: Date())

            return try getCategories(for: req).flatMap(to: View.self) { categories in
                let context = StoryPage(title: "Create Article", story: empty, categories: categories)
                return try req.view().render("admin_edit", context)
            }
        }
    }

    func postAdminEdit(req: Request) throws -> Future<Response> {
        let title: String = try req.content.syncGet(at: "title")
        let strap: String = try req.content.syncGet(at: "strap")
        let content: String = try req.content.syncGet(at: "content")
        let category: Int = try req.content.syncGet(at: "category")
        var slug: String = try req.content.syncGet(at: "slug")

        if slug.count == 0 {
            slug = try title.convertedToSlug()
        } else {
            slug = try slug.convertedToSlug()
        }

        let id = try? req.parameters.next(Int.self)
        let post = Post(id: id, title: title, strap: strap, content: content, category: category, slug: slug, date: Date())

        let uri = "http://localhost:8080/backend/story"

        let request = try req.client().post(uri) { postRequest in
            try postRequest.content.encode(post)
        }

        return request.map(to: Response.self) { response in
            if response.http.status == .ok {
                return req.redirect(to: "/admin")
            } else {
                return Response(http: HTTPResponse(status: .internalServerError), using: req)
            }
        }
    }

    func getCategories(for req: Request) throws -> Future<[Category]> {
        guard self.categories.count == 0 else {
            return Future.map(on: req) { self.categories }
        }

        return try req.client().get("http://localhost:8080/backend/categories").flatMap(to: [Category].self) { response in
            try response.content.decode([Category].self).map(to: [Category].self) { result in
                self.categories = result
                return result
            }
        }
    }
}

