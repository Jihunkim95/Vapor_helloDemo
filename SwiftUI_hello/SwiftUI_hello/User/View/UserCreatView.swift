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
                    List{
                        ForEach(userVM.users, id: \.self){user in
                            NavigationLink(value: user){
                                VStack(alignment: .leading){
                                    Text("사용자명: \(user.username)")
                                        .font(.subheadline)
                                    Text("이메일: \(user.email)")
                                        .font(.subheadline)
                                }
                            }
                            
                        }
                        .onDelete{ indexSet in
                            indexSet.forEach { index in
                                let user = userVM.users[index]
                                userVM.confirmDelete(user: user)
                            }
                        }
                    }
                    .padding()
                    .toolbar{EditButton()}
                    
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
                        //아래는 키보드 숨김
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                    }
                    .padding()
                    .foregroundColor(.blue)
                    
                    Button("취소"){
                        newUserName = ""
                        newEmail = ""
                        // 키보드 숨김
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                    }
                    .padding()
                    .foregroundColor(.blue)
                }

            }
            .padding()
            .background(Color(.systemBackground))
            .alert(isPresented: $userVM.showAlert){
                Alert(title: Text("오류"), message: Text(userVM.alertMessage), dismissButton: .default(Text("확인")))
            }
            
        }
        .onAppear{
            userVM.loadUsers()
        }
        .alert(isPresented: $userVM.showDeleteAlert) {
            Alert(
                title: Text("삭제 확인"),
                message: Text("삭제하시겠습니까?"),
                primaryButton: .destructive(Text("삭제")) {
                    userVM.deleteUser()
                },
                secondaryButton: .cancel()
            )
        }

        
    }
    
}



