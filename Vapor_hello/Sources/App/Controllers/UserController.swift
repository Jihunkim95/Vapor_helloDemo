//
//  File.swift
//  
//
//  Created by 김지훈 on 2024/01/03.
//

import Foundation
import Vapor
import Fluent

func createUser(req: Request) throws -> EventLoopFuture<User> {
    let user = try req.content.decode(User.self)
    return user.save(on: req.db).map { user }
}

func fetchTest(req: Request) throws -> String {
    return "Test data received"
}


func usersQuery(req: Request) throws -> EventLoopFuture<[User]> {
    return User.query(on: req.db).all()
}
