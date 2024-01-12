//
//  Login.swift
//  SwiftUI_hello
//
//  Created by 김지훈 on 2024/01/12.
//

import SwiftUI
  
struct Login: View {
    @State private var err : String = ""
      
    var body: some View {
        Text("Login")
        Button{
            Task {
                do {
                    try await Authentication().googleOauth()
                } catch let e {
                    print(e)
                    err = e.localizedDescription
                }
            }
        }label: {
            HStack {
                Image(systemName: "person.badge.key.fill")
                Text("Sign in with Google")
            }.padding(8)
        }.buttonStyle(.borderedProminent)
          
        Text(err).foregroundColor(.red).font(.caption)
    }
}
