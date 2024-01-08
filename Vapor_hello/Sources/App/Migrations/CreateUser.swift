//
//  File.swift
//  
//
//  Created by 김지훈 on 2024/01/03.
//
import Fluent
import Vapor
import Foundation

//
struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users")
            .field("id", .int, .identifier(auto: true)) // 자동채번 활성화
            .field("username", .string, .required)
            .field("email", .string, .required)
            .field("created_at", .datetime, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users").delete()
    }
}
