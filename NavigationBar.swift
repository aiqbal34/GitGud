//
//  NavigationBar.swift
//  GitGud
//
//  Created by Sajed Hussein on 2/24/24.
//

import SwiftUI

struct NavigationBar: View {
    @State private var selectedTab = "Find Matches"
    init() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(named: "SecondaryBackground") 

        // Use this appearance when the tab bar is in any state
        UITabBar.appearance().standardAppearance = appearance

        // Use this appearance when the tab bar scroll edge appearance is in any state (for example, when the tab bar is scrolled off the screen on iPhone in landscape)
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

     
    var body: some View {
            TabView(selection: $selectedTab) {
                HomeMatchingView()
                    .tabItem {
                        Label("Find Matches", systemImage: "magnifyingglass")
                    }
                    .tag("Find Matches")

                TeamBuilderView()
                    .tabItem {
                        Label("Team Builder", systemImage: "cube.fill")
                    }
                    .tag("Team Builder")
                
                Text("Profile View")
                    .tabItem {
                        Label("Profile", systemImage: "person")

                    }
                    .tag("Profile")
            }
            .foregroundColor(Color.text)
            .accentColor(Color.text)
        }
}

#Preview {
    NavigationBar()
        .modelContainer(for: Item.self, inMemory: true)
}
