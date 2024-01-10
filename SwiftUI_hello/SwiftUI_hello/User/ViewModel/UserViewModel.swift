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
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var showDeleteAlert: Bool = false
    var userToDelete: User?

    private let baseURL = "http://3.39.59.46:8080"
    
    //조회
    func loadUsers() {
        guard let url = URL(string: "\(baseURL)/usersQuery") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching users: \(error)")
                return
            }

            if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601  // ISO 8601 날짜 형식을 사용
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

    //저장
    func addUser(username: String, email: String) {
        let newUser = User(id: nil, username: username, email: email)
        guard let url = URL(string: "\(baseURL)/users") else { return }
        guard let uploadData = try? JSONEncoder().encode(newUser) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = uploadData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async{
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
                    let errorMessage = json?["reason"] as? String ?? "알 수 없는 오류가 발생했습니다."
                    DispatchQueue.main.async{
                        self.alertMessage = errorMessage
                        self.showAlert = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.alertMessage = "알 수 없는 오류가 발생했습니다."
                        self.showAlert = true
                    }
                }
                return
            }
            
            // 사용자 추가 후 사용자 목록을 다시 로드합니다.
            DispatchQueue.main.async {
                self.loadUsers()
            }
        }.resume()
    }
    
    //업데이트
    func updateUser(user: User) {
        guard let url = URL(string: "\(baseURL)/users/\(user.id ?? 0)") else { return }
        guard let uploadData = try? JSONEncoder().encode(user) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = uploadData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                }
                return
            }
            //서버 메세지 받기
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
                    let errorMessage = json?["reason"] as? String ?? "알 수 없는 오류가 발생했습니다."
                    DispatchQueue.main.async{
                        self.alertMessage = errorMessage
                        self.showAlert = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.alertMessage = "알 수 없는 오류가 발생했습니다."
                        self.showAlert = true
                    }
                }
                return
            }
            
            // 사용자 정보 수정 후 사용자 목록을 다시 로드합니다.
            DispatchQueue.main.async {
                self.loadUsers()
            }
        }.resume()
    }
    
    //삭제 전 체크
    func confirmDelete(user: User) {
        self.userToDelete = user
        self.showDeleteAlert = true
    }
    //삭제
    func deleteUser(){
        guard let user = userToDelete else { return }
        guard let url = URL(string: "\(baseURL)/users/\(user.id ?? 0)") else { return }
//        dump(url)
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                }
                return
            }

            DispatchQueue.main.async {
                if let index = self.users.firstIndex(where: { $0.id == user.id }) {
                    self.users.remove(at: index)
                }
                self.userToDelete = nil
                self.showDeleteAlert  = false
            }
        }.resume()
    }
    
}
