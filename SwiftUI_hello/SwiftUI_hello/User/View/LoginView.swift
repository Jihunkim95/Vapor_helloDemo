//
//  LoginView.swift
//  SwiftUI_hello
//
//  Created by 김지훈 on 2024/01/12.
//

import SwiftUI
import Firebase
import GoogleSignInSwift


struct LoginView: View {
    @State private var err : String = ""
      
    var body: some View {
        GoogleSignInButton{
            Task {
                do {
                    try await Authentication().googleOauth()
                } catch let e {
                    print(e)
                    err = e.localizedDescription
                }
            }
        }.frame(width: 300, height: 60, alignment: .center)

          
        Text(err).foregroundColor(.red).font(.caption)
    }
    
}
