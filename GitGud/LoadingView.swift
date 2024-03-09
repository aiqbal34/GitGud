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
    @State var userList: [UserModel] = []
    @State var currUserID: String
    
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
                        do {
                            userList = try await fetchUsersForHomePage(currUser: currUserID)
                            try await userModel.hardCopy(user: fetchCurrentUsersInformation(urlString: "getCurrentUser",currUser: currUserID))
                        } catch {
                            print(error)
                        }
                        
                    } else {
                        do {
                            try await saveNewAccount(userData: userModel, urlString: "createBasicAccount")
                            userList = try await fetchUsersForHomePage(currUser: currUserID)
                            try await userModel.hardCopy(user: fetchCurrentUsersInformation(urlString: "getCurrentUser", currUser: currUserID))
                        }catch {
                            print(error)
                        }
                    }
                    userModel.printModel()
                    move_to_Home = true
                }
                
            }
            .navigationDestination(isPresented: $move_to_Home) {
                
                NavigationBar(userList: userList)
                    .environmentObject(userModel)
            }
        }
    }
}

//#Preview {
//    LoadingView()
//}
