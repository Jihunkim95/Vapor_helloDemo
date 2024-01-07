import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    //연결test시 상위 터미널에서 swift run실행
    // PostgreSQL 데이터베이스 연결 구성
    app.databases.use(.postgres(
        hostname: "my-db-instance.cfwagaqykjab.ap-northeast-2.rds.amazonaws.com",
        username: "postgres",
        password: "qwe12345",
        database: "initial_db"
    ), as: .psql)
    
    app.migrations.add(CreateUser())

    
    // register routes
    try routes(app)
}
