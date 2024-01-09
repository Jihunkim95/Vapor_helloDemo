//
//  UserDetailView.swift
//  SwiftUI_hello
//
//  Created by 김지훈 on 2024/01/08.
//

import SwiftUI

struct UserDetailView: View {
    
    @ObservedObject var userVM: UserViewModel
    @State var user: User

    
    var body: some View {
        VStack{
            TextField("Username", text: $user.username)
            TextField("Email", text: $user.email)
//            TextField("id", value: $user.id, formatter: NumberFormatter())
                Button("Save") {
                    // 저장 로직
                    userVM.updateUser(user: user)
                }
        }
        .navigationTitle(user.username)
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $userVM.showAlert){
            Alert(title: Text("오류"), message: Text(userVM.alertMessage), dismissButton: .default(Text("확인")))
        }


    }
}

