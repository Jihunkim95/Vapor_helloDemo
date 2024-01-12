//
//  ContentView.swift
//  SwiftUI_hello
//
//  Created by 김지훈 on 2024/01/12.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignInSwift
import GoogleSignIn

struct ContentView: View {
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)
  
    var body: some View {
        VStack {
            if userLoggedIn {
                HomeView()
            } else {
                LoginView()
            }
        }.onAppear{
            //Firebase state change listeneer
            Auth.auth().addStateDidChangeListener{ auth, user in
                if (user != nil) {
                    userLoggedIn = true
                } else {
                    userLoggedIn = false
                }
            }
        }
    }
}
