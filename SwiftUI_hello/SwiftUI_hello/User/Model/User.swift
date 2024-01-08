//
//  User.swift
//  SwiftUI_hello
//
//  Created by 김지훈 on 2024/01/08.
//

import Foundation

struct User: Codable, Identifiable, Hashable {
    var id: Int? //DB에서 자동 채번됨
    var username: String
    var email: String
//    var createdAt: Date?
}
