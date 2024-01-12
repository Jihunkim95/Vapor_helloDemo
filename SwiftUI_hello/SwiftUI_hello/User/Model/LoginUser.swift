//
//  LoginUser.swift
//  SwiftUI_hello
//
//  Created by 김지훈 on 2024/01/12.
//

import Foundation

struct LoginUser {
    var url: URL?
    var name: String
    var email: String
    
    init(url: URL? = nil, name: String, email: String) {
        self.url = url
        self.name = name
        self.email = email
    }
}
