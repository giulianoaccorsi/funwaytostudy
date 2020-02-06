import Fluent
import FluentSQLite
import Foundation
import Leaf
import Vapor

public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
    ) throws {
    // register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // configure your application here
    try services.register(LeafProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    
    let directoryConfig = DirectoryConfig.detect()
    services.register(directoryConfig)
    
    try services.register(FluentSQLiteProvider())
    
    var databaseConfig = DatabasesConfig()
    let db = try SQLiteDatabase(storage: .file(path: "\(directoryConfig.workDir)instantcoder.db"))
    databaseConfig.add(database: db, as: .sqlite)
    services.register(databaseConfig)
    
    var migrationConfig = MigrationConfig()
    migrationConfig.add(model: User.self, database: .sqlite)
    migrationConfig.add(model: Project.self, database: .sqlite)
    services.register(migrationConfig)
    
    var middlewareConfig = MiddlewareConfig.default()
    middlewareConfig.use(SessionsMiddleware.self)
    services.register(middlewareConfig)
    config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)
}

