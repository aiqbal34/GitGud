//
//  NavigationBar.swift
//  GitGud
//
//  Created by Sajed Hussein on 2/24/24.
//

import SwiftUI

/*
 - Navigation tool bar to swtich between views
 */
struct NavigationBar: View {
    
    // @objects
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var UserTeams: UserTeamData
    var userList: [UserModel]
 
    // Current selection
    @State var selectedTab: String
  
    var body: some View {
            TabView(selection: $selectedTab) {
               HackathonsView()
                    .tabItem {
                        Label("Find Matches", systemImage: "magnifyingglass")
                    }
                    .tag("Find Matches")

                TeamBuilderView()
                    .environmentObject(userModel)
                    .environmentObject(UserTeams)
                    .tabItem {
                        Label("Team Builder", systemImage: "cube.fill")
                    }
                    .tag("Team Builder")
                
                

                ConnectionsView()
                    .environmentObject(userModel)
                    .environmentObject(UserTeams)
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
            .toolbarBackground(Color.white, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
            .foregroundColor(Color(hex: "#543C86"))
            .tint(Color.black)
            .navigationBarBackButtonHidden()


        }
}

// Bubble UI for the skillss
struct RoundedTabBar: Shape {
    func path(in rect: CGRect) -> Path {
        let cornerRadius = CGFloat(10)
        let path = Path(roundedRect: rect, cornerRadius: cornerRadius)
        return path
    }
}
