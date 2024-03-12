//
//  NavigationBar.swift
//  GitGud
//
//  Created by Sajed Hussein on 2/24/24.
//

import SwiftUI

struct NavigationBar: View {
    
   
    
    @EnvironmentObject var userModel: UserModel
    var userList: [UserModel]
 
    @State var selectedTab: String
  

     
    var body: some View {
            TabView(selection: $selectedTab) {
                MatchingView(userList: userList, pickMember: false)
                    .environmentObject(userModel)
                    .tabItem {
                        Label("Find Matches", systemImage: "magnifyingglass")
                    }
                    .tag("Find Matches")

                TeamBuilderView()
                    .environmentObject(userModel)
                    .tabItem {
                        Label("Team Builder", systemImage: "cube.fill")
                    }
                    .tag("Team Builder")
                
                

                ConnectionsView()
                    .environmentObject(userModel)
                    .tabItem {
                        Label("Connections", systemImage: "network")
                    }
                    .tag("Connections")
                
                SettingsView()
                    .environmentObject(userModel)
                    .tabItem {
                        Label("Profile", systemImage: "person")

                    }
                    .tag("Profile")
                
            }
            .background(Color.secondaryBackground)
            .foregroundColor(Color.text)
            .accentColor(Color.text)
            .navigationBarBackButtonHidden()
        }
}

