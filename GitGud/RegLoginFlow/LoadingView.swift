//
//  LoadingView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/28/24.
//

import SwiftUI

/*
 - Fetches users from data base to populate homeView
 - Creates account, if needed
 -
 */
struct LoadingView: View {
    // @Objects
    @EnvironmentObject var userModel: UserModel
    
    @State var move_to_Home = false
    @State var userList: [UserModel] = []
    @State var currUserID: String
    @State var isError: Bool = false
    @StateObject var UserTeams = UserTeamData()


    var getData: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientStyles.backgroundGradient
                    .ignoresSafeArea()
                ProgressView("Loading…", value: 0.99)
                    .progressViewStyle(CircularProgressViewStyle(tint: .text))
                    .scaleEffect(1.5)
                    .foregroundColor(.text)
                    .monospaced()
            }.onAppear {
                Task {
                    // Fetches users from database
                    if (getData) {
                        do {
                            userList = try await fetchUsersForHomePage(currUser: currUserID)
                            try await userModel.hardCopy(user: fetchCurrentUsersInformation(urlString: "getCurrentUser",currUser: currUserID))
                            try await UserTeams.hardCopy(userTeams: fetchCurrentUserTeam(currUser: currUserID))
                        } catch {
                            isError = true
                            print(error)
                        }
                        
                    } else {
                        // Stores new account in data base and fetch new users
                        do {
                            try await saveNewAccount(userData: userModel, urlString: "createBasicAccount")
                            userList = try await fetchUsersForHomePage(currUser: currUserID)
                            try await userModel.hardCopy(user: fetchCurrentUsersInformation(urlString: "getCurrentUser", currUser: currUserID))
                            try await UserTeams.hardCopy(userTeams: fetchCurrentUserTeam(currUser: currUserID))
                        }catch {
                            isError = true
                            print(error)
                        }
                    }
                    userModel.printModel()
                    print("This is the team Connections + \(UserTeams.teamConnections)")
                    move_to_Home = true
                }
                
            }

            .navigationDestination(isPresented: $isError) {
                LoginView()
                    .environmentObject(userModel)
            }
            .alert(isPresented: $isError) {
                // Content of the alert
                Alert(title: Text("Login Failed"), message: Text("Login Failed Try again"), dismissButton: .default(Text("Cancel")))
            }
            .navigationDestination(isPresented: $move_to_Home) {
                
                NavigationBar(userList: userList, selectedTab: "Find Matches")
                    .environmentObject(userModel)
                    .environmentObject(UserTeams)
                  
            }
        }
    }
}

//#Preview {
//    LoadingView()
//}
