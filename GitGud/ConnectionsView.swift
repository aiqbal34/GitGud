//
//  ConnectionsView.swift
//  GitGud
//
//  Created by Isa Bukhari on 2/29/24.
//

import SwiftUI

struct ConnectionsView: View {
    
    
    //These two values are for the picker
    @State var viewSelection = "Connections"
    var selectionOptions = ["Connections", "Requests"]
    
    @EnvironmentObject var userModel: UserModel
    
    var body: some View {
       
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                VStack{
                    List {
                        Picker("", selection: $viewSelection) {
                            ForEach(selectionOptions, id: \.self) { item in
                                Text(item)
                                    .foregroundColor(.blue) // Change the text color
                                    .font(.headline) // Set the font style
                                    .padding() // Add some padding around each text
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle()) // Apply MenuPickerStyle
                        .listRowBackground(Color.secondaryBackground)
                        .foregroundColor(Color.text)
                        
                        if (viewSelection == "Connections"){
                            Connections()
                        }
                        if (viewSelection == "Requests") {
                            RequestsView()
                                .environmentObject(userModel)
                        }
                        
                        
                    }
                    .scrollContentBackground(.hidden)
                    .foregroundColor(Color.text)
                }
            }
        
    }
}
struct Connections: View {
    @State var connections = ["Sally", "Bob", "Rob", "John"]
    @State var teamConnections = ["StartUp1", "HackathonTeam", "BestBuddies"]
    @State var moveToTeamDetailView = false
    @State var selectedTeam = ""
    var body: some View {
        
        
            Section(header: Text("Connections")){
                ForEach(connections, id: \.self) { member in
                    Text(member)
                }
                .listRowBackground(Color.secondaryBackground)
            }
            
            Section(header: Text("Teams")){
                ForEach(teamConnections, id: \.self) { team in
                    Text(team)
                        .onTapGesture {
                            moveToTeamDetailView = true
                            selectedTeam = team
                        }
                }
                .listRowBackground(Color.secondaryBackground)
                .navigationDestination(isPresented: $moveToTeamDetailView){
                    TeamDetailView(teamName: selectedTeam)
                }
            }
    }
}


struct TeamDetailView: View {
    var teamName: String

    var body: some View {
        ScrollView {
            // Display team information and members here
            //Text("Team: \(teamName)")
            // Add more details and members as needed
        }
        .navigationBarTitle(Text(teamName), displayMode: .inline)
    }
}

struct RequestsView: View {
    @EnvironmentObject var userModel: UserModel
    @State var teamRequests = ["BestTeam", "TeamHackers", "Buddies"]
    
    //These two values are for the picker
    @State var viewSelection = ""
    var selectionOptions = ["Connections", "Requests"]
    var body: some View {
        
        Section(header: Text("Requests")){
            ForEach(userModel.requests, id: \.self) { member in
                Text("\(member.name) \n \(member.email)")
            }
            .listRowBackground(Color.secondaryBackground)
        }
        
        Section(header: Text("Teams Requests")){
            ForEach(teamRequests, id: \.self) { team in
                Text(team)
            }
            .listRowBackground(Color.secondaryBackground)
        }
    }

}


#Preview {
    ConnectionsView()
}
