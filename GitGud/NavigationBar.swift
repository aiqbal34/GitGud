//
//  NavigationBar.swift
//  GitGud
//
//  Created by Sajed Hussein on 2/24/24.
//

import SwiftUI

struct NavigationBar: View {
    @State private var selectedTab = "Find Matches"
    
    var body: some View {
        HStack{
            TabView(selection: $selectedTab) {
                Text("Find Matches View")
                    .tabItem {
                        Label("Find Matches", systemImage: "magnifyingglass")
                    }
                    .tag("Find Matches")
                
                HomeMatchingView()
                    .tabItem {
                        Label("Connections", systemImage: "person.2")
                            .foregroundColor(Color.text)

                        
                    }
                    .tag("Connections")
                
                
                Text("Profile View")
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    .tag("Profile")
                
            }
        }
    }
}

#Preview {
    NavigationBar()
        .modelContainer(for: Item.self, inMemory: true)
}
