@testable import App
import Vapor
import XCTest

final class AppTests: XCTestCase {
    var app: Application!
    
    override func setUp() {
        do {
            var config = Config.default()
            var env = try Environment.detect()
            var services = Services.default()
            env.commandInput.arguments = []

            try App.configure(&config, &env, &services)

            app = try Application(
                config: config,
                environment: env,
                services: services
            )

            try App.boot(app)
            try app.asyncRun().wait()
        } catch {
            fatalError("Failed to launch Vapor server: \(error.localizedDescription)")
        }

        _ = try? app.client().get("http://localhost:8080/backend/reset").wait()
    }
    
    override func tearDown() {
        try? app.runningServer?.close().wait()
    }
    
    func createPost() -> Post {
        let title = "Hello, world"
        let strap = "This is a strap"
        let content = "This is some content"
        let category = 1
        let slug = "hello-world"
        
        return Post(id: nil, title: title, strap: strap, content: content, category: category, slug: slug, date: Date())
    }
    
    func testNoStories() throws {
        let response = try app.client().get("http://localhost:8080/backend/stories").wait()
        let posts = try response.content.syncDecode([Post].self)
        XCTAssertEqual(posts.count, 0, "There should be no stories")
    }
    
    func testNonexistentStory() throws {
        let response = try app.client().get("http://localhost:8080/backend/story/556").wait()
        let post = try? response.content.syncDecode(Post.self)
        XCTAssertNil(post)
    }
    
    func testCreateStory() throws {
        _ = try app.client().post("http://localhost:8080/backend/story") { postRequest in
            try postRequest.content.encode(createPost())
        }.wait()

        let response = try app.client().get("http://localhost:8080/backend/stories").wait()
        let posts = try response.content.syncDecode([Post].self)
        XCTAssertEqual(posts.count, 1, "There should be one story")
    }
    
    func testCreateBadStory() throws {
        let content = ["content": "This isn't really a post"]

        let response = try app.client().post("http://localhost:8080/backend/story") { postRequest in
            try postRequest.content.encode(content)
        }.wait()

        let post = try? response.content.syncDecode(Post.self)
        XCTAssertNil(post, "Creating an invalid story should fail")
    }

    func testUpdateStory() throws {
        _ = try app.client().post("http://localhost:8080/backend/story") { postRequest in
            try postRequest.content.encode(createPost())
        }.wait()

        let createResponse = try app.client().get("http://localhost:8080/backend/stories").wait()
        let posts = try createResponse.content.syncDecode([Post].self)
        
        if var testPost = posts.first {
            testPost.title = "Modified"

            let updateResponse = try app.client().post("http://localhost:8080/backend/story") { postRequest in
                try postRequest.content.encode(testPost)
            }.wait()

            _ = try updateResponse.content.syncDecode(Post.self)
        } else {
            XCTFail("Unable to fetch the post we created.")
        }
    }
    
    func testUpdateBadStory() throws {
        var badPost = createPost()
        badPost.id = 556
        
        let response = try app.client().post("http://localhost:8080/backend/story") { postRequest in
            try postRequest.content.encode(badPost)
        }.wait()

        _ = try response.content.syncDecode(Post.self)
    }
    
    static let allTests = [
        ("testNoStories", testNoStories),
        ("testNonexistentStory", testNonexistentStory),
        ("testCreateStory", testCreateStory),
        ("testCreateBadStory", testCreateBadStory),
        ("testUpdateStory", testUpdateStory),
        ("testUpdateBadStory", testUpdateBadStory),
    ]
}

