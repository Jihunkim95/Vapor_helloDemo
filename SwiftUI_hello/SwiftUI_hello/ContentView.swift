//
//  ContentView.swift
//  SwiftUI_hello
//
//  Created by 김지훈 on 2024/01/03.
//
import SwiftUI

struct User: Codable, Identifiable {
    var id: Int? //DB에서 자동 채번됨
    var username: String
    var email: String
    var createdAt: Date?
}

// ViewModel
class UserListViewModel: ObservableObject{
    @Published var users: [User] = []
    
    func loadUsers() {
        guard let url = URL(string: "http://127.0.0.1:8080/usersQuery") else { return }

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
        let newUser = User(id: nil, username: username, email: email, createdAt: nil)
        guard let url = URL(string: "http://127.0.0.1:8080/users") else { return }
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
}

// View
struct UserListView: View {
    @StateObject private var viewModel = UserListViewModel()
    @State private var newUserName:String = ""
    @State private var newEmail:String = ""
    
    var body: some View{
        VStack{
            Section(header: Text("사용자 목록").font(.title)){
                Divider()
                List(viewModel.users){ user in
                    VStack(alignment: .leading){
                        Text("사용자명: \(user.username)")
                            .font(.subheadline)
                        Text("이메일: \(user.email)")
                            .font(.subheadline)
                    }
                }.padding()
            }
            
            HStack{
                Text("사용자")
                TextField("사용자 입력", text: $newUserName)
                    .padding()
                    .background(.white)
            }
            HStack{
                Text("이메일")
                TextField("이메일 입력", text: $newEmail)
                    .padding()
                    .background(.white)
            }
            HStack{
                Button("입력"){
                    viewModel.addUser(username: newUserName, email: newEmail)
                }
                .padding()
                .foregroundColor(.blue)
            }

        }
        .padding()
        .background(Color(.systemBackground))
        .onAppear{
            viewModel.loadUsers()
        }
        
    }
    
}

#Preview {
    UserListView()

}


