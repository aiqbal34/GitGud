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
//    init() {
//        let appearance = UITabBarAppearance()
//        appearance.backgroundColor = UIColor(named: "SecondaryBackground") 
//
//        // Use this appearance when the tab bar is in any state
//        UITabBar.appearance().standardAppearance = appearance
//
//        // Use this appearance when the tab bar scroll edge appearance is in any state (for example, when the tab bar is scrolled off the screen on iPhone in landscape)
//        if #available(iOS 15.0, *) {
//            UITabBar.appearance().scrollEdgeAppearance = appearance
//        }
//    }

     
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

//#Preview {
//    NavigationBar()
//        .modelContainer(for: Item.self, inMemory: true)
//}