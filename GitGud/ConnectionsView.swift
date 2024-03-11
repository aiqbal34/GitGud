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
                                .environmentObject(userModel)
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
    
    @EnvironmentObject var userModel: UserModel
    var body: some View {
        
        
            Section(header: Text("Connections")){
                if userModel.connections.count > 0 {
                    ForEach(userModel.connections, id: \.self) { member in
                        VStack {
                            Text("\(member.name)")
                            Text("\(member.email)")
                        }
                    }
                    .listRowBackground(Color.secondaryBackground)
                } else {
                    Text("No Connections")
                }
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
            if userModel.requests.count > 0 {
                ForEach(userModel.requests.indices, id: \.self) { index in
                    let member = userModel.requests[index]
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(member.name)")
                            Text("\(member.email)")
                        }
                        Spacer()
                        HStack(spacing: 20) {
                            Button(action: {
                                Task {
                                    do {
                                        try await accpetUser(currUser: userModel.userID, acceptUser: member.userID)
                                        
                                    } catch {
                                        print(error)
                                    }
                                }
                                userModel.requests.remove(at: index)
                                userModel.connections.append(member)
                                
                            }) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                            }
                            Button(action: {
                                member.printModel()
                                Task {
                                    do {
                                        try await rejectUser(currUser: userModel.userID, rejectedUser: member.userID)
                                        // Remove the rejected user from the requests array
                                        
                                    } catch {
                                        print(error)
                                    }
                                }
                                for element in userModel.requests {
                                    if element == member {
                                        if let index = userModel.requests.firstIndex(of: element) {
                                            userModel.requests.remove(at: index)
                                        }
                                    }
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(Color.secondaryBackground)
                }
                .listRowBackground(Color.secondaryBackground)
            } else {
                Text("No Requests")
            }
        }
        //TODO
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
