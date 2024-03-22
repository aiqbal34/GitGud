//
//  NavigationBar.swift
//  GitGud
//
//  Created by Sajed Hussein on 2/24/24.
//

import SwiftUI

struct NavigationBar: View {
    
   
    
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var UserTeams: UserTeamData
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
            .toolbarBackground(Color.secondaryBackground, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
            .foregroundColor(Color.text)
            .tint(Color.black)
            .navigationBarBackButtonHidden()


        }
}
struct RoundedTabBar: Shape {
    func path(in rect: CGRect) -> Path {
        let cornerRadius = CGFloat(10)
        let path = Path(roundedRect: rect, cornerRadius: cornerRadius)
        return path
    }
}
/*      */
