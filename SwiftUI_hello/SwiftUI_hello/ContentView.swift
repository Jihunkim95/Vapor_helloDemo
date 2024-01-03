//
//  ContentView.swift
//  SwiftUI_hello
//
//  Created by 김지훈 on 2024/01/03.
//
import SwiftUI

struct CreateUserView: View {
    @State private var username: String = ""
    @State private var email: String = ""

    var body: some View {
        VStack {
            TextField("Username", text: $username)
            TextField("Email", text: $email)
            Button("계정 생성", action: createUser)
            Button("Get Test", action: fetchTest)
        }
    }

    func createUser() {
        guard let url = URL(string: "http://127.0.0.1:8080/users") else { return }

        let user = User(username: username, email: email, createdAt: nil)
        guard let uploadData = try? JSONEncoder().encode(user) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = uploadData
        print(uploadData)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error occurred: \(error)")
                return
            }
            // Handle the response here
        }.resume()
    }
    
    func fetchTest() {
        guard let url = URL(string: "http://127.0.0.1:8080/test") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error occurred: \(error)")
                return
            }
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Data received: \(dataString)")
            }
        }.resume()
    }
    
}

struct User: Codable {
    var username: String
    var email: String
    var createdAt: Date?
}
