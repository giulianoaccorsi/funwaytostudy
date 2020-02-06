//
//  BackEnd.swift
//  App
//
//  Created by Paul Hudson on 30/12/2017.
//

import Foundation
import Fluent
import Vapor

class BackEnd: RouteCollection {
    func boot(router: Router) throws {
        router.group("backend") { group in
            group.get("stories", use: fetchStories)
            group.get("story", Int.parameter, use: fetchStory)
            group.get("categories", use: getAllCategories)
            group.post("story", use: postAdminEdit)
        }
    }
    
    func fetchStories(on req: Request) throws -> Future<[Post]> {
        return Post.query(on: req).sort(\Post.date, .descending).all()
    }
    
    func fetchStory(on req: Request) throws -> Future<Post> {
        // pull out the story that was requested
        let id = try req.parameters.next(Int.self)
        
        // look for it in our table
        return Post.find(id, on: req).map(to: Post.self) { post in
            // if it wasn't found throw a 404
            guard let post = post else {
                throw Abort(.notFound)
            }
            
            // otherwise return it
            return post
        }
    }
    
    func getAllCategories(on req: Request) throws -> Future<[Category]> {
        return Category.query(on: req).all()
    }
    
    func postAdminEdit(req: Request) throws -> Future<Post> {
        let post = try req.content.syncDecode(Post.self)
        return post.save(on: req)
    }
}
