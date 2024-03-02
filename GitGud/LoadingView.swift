//
//  LoadingView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/28/24.
//

import SwiftUI

struct LoadingView: View {
    @EnvironmentObject var userModel: UserModel
    
    @State var move_to_Home = false
    @State var result: [UserModel] = []
    
    var getData: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background).ignoresSafeArea()
                ProgressView("Loading…", value: 0.99)
                    .progressViewStyle(CircularProgressViewStyle(tint: .text))
                    .scaleEffect(1.5)
                    .foregroundColor(.text)
                    .monospaced()
            }.onAppear {
                Task {
                    if (getData) {
                        //pull the currenct users information
                        print("hello")
                        result = try await fetchData()
                        print(result)
                    } else {
                        try await postData(userData: userModel, urlString: "createBasicAccount")
                        result = try await fetchData()
                    }

                    move_to_Home = true
                }
            }
            .navigationDestination(isPresented: $move_to_Home) {
                NavigationBar(userList: result)
                    .environmentObject(userModel)
            }
        }
    }
}

//#Preview {
//    LoadingView()
//}
