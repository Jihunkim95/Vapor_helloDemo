//
//  File.swift
//  
//
//  Created by 김지훈 on 2024/01/03.
//

import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"
    
    @ID(custom: "id", generatedBy: .database)
    var id: Int?

    @Field(key: "username")
    var username: String

    @Field(key: "email")
    var email: String

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() {}

    init(id: Int?, username: String, email: String, createdAt: Date? = nil) {
        self.id = id
        self.username = username
        self.email = email
        self.createdAt = createdAt
    }
}
