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
    @State var selectedTeam: Team = Team(people: [], ids: [], emails: [], project: ProjectBuild(projectName: "", description: "", teamSize: 0, projectType: ""))
    
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
            if userModel.teamConnections.count > 0 {
                ForEach(userModel.teamConnections, id: \.self) { team in
                    VStack {
                        Text(team.project.projectName)
                    }
                    .onTapGesture {
                        moveToTeamDetailView = true
                        selectedTeam = team
                    }
                }
                .listRowBackground(Color.secondaryBackground)
                .navigationDestination(isPresented: $moveToTeamDetailView){
                    TeamDetailView(teamName: selectedTeam)
                }
            } else {
                Text("No Team Connections")
            }
        }
    }
}


struct TeamDetailView: View {
    var teamName: Team
    
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            VStack {
                Text(teamName.project.description)
                Text(teamName.emails[0])
                Text(teamName.people[0])
            }

        }
        .background(Color.secondaryBackground)
        .foregroundColor(Color.text)
        .accentColor(Color.text)
        .ignoresSafeArea()
        .navigationBarTitle(Text(teamName.project.projectName), displayMode: .inline)
    }
}

struct RequestsView: View {
    @EnvironmentObject var userModel: UserModel
    @State var teamRequests = ["BestTeam", "TeamHackers", "Buddies"]
    @State var moveToTeamDetailView = false
    @State var selectedTeam: Team = Team(people: [], ids: [], emails: [], project: ProjectBuild(projectName: "", description: "", teamSize: 0, projectType: ""))
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
            ForEach(userModel.teamRequests, id: \.self) { team in
                HStack {
                    VStack {
                        Text(team.project.projectName)
                    }
                    .onTapGesture {
                        moveToTeamDetailView = true
                        selectedTeam = team
                    }
                    Spacer()
                    HStack(spacing: 20) {
                        Button(action: {
                            
                            Task {
                                var reUser: UserModel
                                do {
                                    try await acceptTeam(currUser: userModel.userID, teamDescription: team)
                                    reUser = try await fetchCurrentUsersInformation(urlString: "getCurrentUser" ,currUser: userModel.userID)
                                    userModel.teamConnections = reUser.teamConnections
                                } catch {
                                    print(error)
                                }
                                
                            }
                        }) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                        }
                        Button(action: {
                            Task {
                                do {
                                    try await rejectTeam(currUser: userModel.userID, teamDescription: team)
                                } catch {
                                    print(error)
                                }
                                
                            }
                            for element in userModel.teamRequests {
                                if element == team {
                                    if let index = userModel.teamRequests.firstIndex(of: element) {
                                        userModel.teamRequests.remove(at: index)
                                    }
                                }
                            }
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .listRowBackground(Color.secondaryBackground)
            .navigationDestination(isPresented: $moveToTeamDetailView){
                TeamDetailView(teamName: selectedTeam)
            }
        }
    }
    
}


#Preview {
    ConnectionsView()
}
