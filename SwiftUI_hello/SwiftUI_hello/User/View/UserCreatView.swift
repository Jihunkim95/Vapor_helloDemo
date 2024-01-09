//
//  ContentView.swift
//  SwiftUI_hello
//
//  Created by 김지훈 on 2024/01/03.
//
import SwiftUI



// View
struct UserListView: View {
    @StateObject private var userVM = UserViewModel()
    @State private var newUserName:String = ""
    @State private var newEmail:String = ""
    
    var body: some View{
        NavigationStack{
            VStack{
                Section(header: Text("사용자 목록").font(.title)){
                    Divider()
                    List(userVM.users){ user in
                        NavigationLink(value: user){
                            VStack(alignment: .leading){
                                Text("사용자명: \(user.username)")
                                    .font(.subheadline)
                                Text("이메일: \(user.email)")
                                    .font(.subheadline)
                            }
                        }

                    }.padding()
                    
                }.navigationDestination(for: User.self) { user in
                    UserDetailView(userVM: userVM, user: user)
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
                        userVM.addUser(username: newUserName, email: newEmail)
                    }
                    .padding()
                    .foregroundColor(.blue)
                }

            }
            .padding()
            .background(Color(.systemBackground))
            
        }
        .onAppear{
            userVM.loadUsers()
        }
        .alert(isPresented: $userVM.showAlert){
            Alert(title: Text("오류"), message: Text(userVM.alertMessage), dismissButton: .default(Text("확인")))
        }

        
    }
    
}

#Preview {
    UserListView()

}


