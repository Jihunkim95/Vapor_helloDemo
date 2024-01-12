//
//  SwiftUI_helloApp.swift
//  SwiftUI_hello
//
//  Created by 김지훈 on 2024/01/03.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        FirebaseApp.configure()
      return GIDSignIn.sharedInstance.handle(url)
    }
    

}


@main
struct SwiftUI_helloApp: App {
    
    init() {
        // Firebase initialization
        FirebaseApp.configure()
    }
  
    var body: some Scene {
        WindowGroup {
            ContentView().onOpenURL { url in
                //Handle Google Oauth URL
                GIDSignIn.sharedInstance.handle(url)
            }  
        }
    }
}
