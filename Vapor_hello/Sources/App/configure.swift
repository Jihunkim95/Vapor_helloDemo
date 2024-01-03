import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // PostgreSQL 데이터베이스 연결 구성
    app.databases.use(.postgres(
        hostname: "localhost",
        username: "kimjihun",
        password: "3274",
        database: "testhoon"
    ), as: .psql)
    
    app.migrations.add(CreateUser())

    
    // register routes
    try routes(app)
}
