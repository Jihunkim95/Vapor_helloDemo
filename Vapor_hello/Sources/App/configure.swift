import Fluent
import FluentPostgresDriver
import Vapor
import NIOSSL

// configures your application
public func configure(_ app: Application) async throws {
    //EC2 서버용
    let tlsConfiguration = TLSConfiguration.makeServerConfiguration(
        certificateChain: try NIOSSLCertificate.fromPEMFile("/etc/letsencrypt/archive/cafeconnect.store/fullchain1.pem").map { .certificate($0) },
        privateKey: .file("/etc/letsencrypt/archive/cafeconnect.store/privkey1.pem")
    )

    app.http.server.configuration.tlsConfiguration = tlsConfiguration
    
    //외부 접속허용
    app.http.server.configuration.serverName = "0.0.0.0"

    //연결test시 상위 터미널에서 swift run실해
    // PostgreSQL 데이터베이스 연결 구성
    app.databases.use(.postgres(
        hostname: "cafeprojectdb.cxfmuelgpwdj.ap-southeast-2.rds.amazonaws.com",
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
