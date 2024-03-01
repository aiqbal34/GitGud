//
//  GitGudApp.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/21/24.
//

import SwiftUI
import FirebaseCore


//

@main
struct GitGudApp: App {

    init() {
        FirebaseApp.configure()
    }
    
    @StateObject var userModel = UserModel()
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(userModel)
        }
    }
}
