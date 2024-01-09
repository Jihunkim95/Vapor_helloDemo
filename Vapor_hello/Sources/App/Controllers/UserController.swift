//
//  File.swift
//  
//
//  Created by 김지훈 on 2024/01/03.
//

import Foundation
import Vapor
import Fluent
import SQLKit

//func create(req: Request) async throws -> User {
//    let newUser = try req.content.decode(User.self)
//    if try await User.query(on: req.db)
//        .filter(\.$username == newUser.username)
//        .first()
//        .get() != nil{
//        throw Abort(.badRequest, reason: "사용중인 사용자명")
//    }
//    try await newUser.save(on: req.db)
//    return newUser
//}
struct UserController {
    func create(req: Request) async throws -> User {
        let newUser = try req.content.decode(User.self)
        
        let sqlDb = req.db as! SQLDatabase
        
        let existsQuery = sqlDb.raw(
            SQLQueryString("SELECT EXISTS (SELECT 1 FROM users WHERE username = \(bind: newUser.username))")
        )
        
        let result = try await existsQuery.first(decoding: [String: Bool].self).get()
        let exists = result?["exists"] ?? false
        
        if exists {
            throw Abort(.badRequest, reason: "사용중인 사용자명")
        }
        
        try await newUser.save(on: req.db)
        return newUser
    }

    func update(req: Request) async throws -> User {
        guard let userID = req.parameters.get("userID", as: Int.self) else {
            throw Abort(.badRequest, reason: "Invalid user ID.")
        }
        let input = try req.content.decode(User.self)

        // 데이터베이스에 직접 쿼리를 실행하여 username 중복 체크
        let sqlDb = req.db as! SQLDatabase
        let existsQuery = sqlDb.raw(
            SQLQueryString("SELECT EXISTS (SELECT 1 FROM users WHERE username = \(bind: input.username) AND id != \(bind: userID))")
        )

        
        // 쿼리 실행
        let row = try await existsQuery.first().get()
        
        // 적절한 컬럼 이름 또는 인덱스를 사용하여 값을 추출
        let exists: Bool = try row?.decode(column: "exists", as: Bool.self) ?? false

        if exists {
            throw Abort(.badRequest, reason: "수정: 사용중인 사용자명입니다.")
        }


        // 사용자 정보 업데이트
        try await sqlDb.raw(SQLQueryString(
            "UPDATE users SET username = \(bind: input.username), email = \(bind: input.email) WHERE id = \(bind: userID)")
        ).run()

        // 업데이트된 사용자 정보 반환
        guard let updatedUser = try await User.find(userID, on: req.db) else {
            throw Abort(.notFound)
        }

        return updatedUser
    }


    func all(req: Request) async throws -> [User] {
        try await User.query(on: req.db).all()
    }
}
