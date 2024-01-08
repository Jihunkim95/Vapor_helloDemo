//
//  UserViewModel.swift
//  SwiftUI_hello
//
//  Created by 김지훈 on 2024/01/08.
//

import Foundation

// ViewModel
class UserViewModel: ObservableObject{
    @Published var users: [User] = []
    
    func loadUsers() {
        guard let url = URL(string: "http://0.0.0.0:8080/usersQuery") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching users: \(error)")
                return
            }

            if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601  // ISO 8601 날짜 형식을 사용합니다.
                if let decodedUsers = try? decoder.decode([User].self, from: data) {
                    DispatchQueue.main.async {
                        self.users = decodedUsers
                    }
                } else {
                    print("Invalid response from server")
                }
            }
        }.resume()
    }

    func addUser(username: String, email: String) {
        let newUser = User(id: nil, username: username, email: email)
        guard let url = URL(string: "http://0.0.0.0:8080/users") else { return }
        guard let uploadData = try? JSONEncoder().encode(newUser) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = uploadData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error occurred: \(error)")
                return
            }
            // 사용자 추가 후 사용자 목록을 다시 로드합니다.
            DispatchQueue.main.async {
                self.loadUsers()
            }
        }.resume()
    }
    
    func updateUser(user: User) {
        guard let url = URL(string: "http://0.0.0.0:8080/users/\(user.id ?? 0)") else { return }
        guard let uploadData = try? JSONEncoder().encode(user) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = uploadData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error occurred: \(error)")
                return
            }
            // 사용자 정보 수정 후 사용자 목록을 다시 로드합니다.
            DispatchQueue.main.async {
                self.loadUsers()
            }
        }.resume()
    }
    
}
