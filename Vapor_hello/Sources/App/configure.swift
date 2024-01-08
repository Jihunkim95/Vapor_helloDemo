import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    //연결test시 상위 터미널에서 swift run실해
    // PostgreSQL 데이터베이스 연결 구성
    app.databases.use(.postgres(
        hostname: "my-db-instance.cfwagaqykjab.ap-northeast-2.rds.amazonaws.com",
        port: 5432, username: "postgres",
        password: "qwe12345",
        database: "initial_db",
        tlsConfiguration: .forClient(certificateVerification: .none)
    ), as: .psql)
    
    // 마이그레이션 추가
    app.migrations.add(CreateUser())


    // register routes
    try routes(app)
    //마이그레이션 자동실행
    try await app.autoMigrate().get()
//    try await app.autoMigrate().get()
}
