//
//  ConnectionsView.swift
//  GitGud
//
//  Created by Isa Bukhari on 2/29/24.
//

import SwiftUI

/*
 - Segmented view-> Connections/Request
 - Accept/reject requests
 - View team details
 */
struct ConnectionsView: View {
    
    
    // These two values are for the picker
    @State var viewSelection = "Connections"
    var selectionOptions = ["Connections", "Requests"]
    
    // @Objects
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var UserTeams: UserTeamData
    
    var body: some View {
        
        ZStack {
            GradientStyles.backgroundGradient.ignoresSafeArea()
            
            // Segmented View control
            VStack{
                List {
                    Picker("", selection: $viewSelection) {
                        ForEach(selectionOptions, id: \.self) { item in
                            Text(item)
                                .foregroundColor(.blue)
                                .font(.headline)
                                .padding()
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .listRowBackground(Color.white)
                    .foregroundColor(Color(hex: "#543C86"))
                    
                    if (viewSelection == "Connections"){
                        Connections()
                            .environmentObject(UserTeams)
                            .environmentObject(userModel)
                    }
                    if (viewSelection == "Requests") {
                        RequestsView()
                            .environmentObject(UserTeams)
                            .environmentObject(userModel)
                    }
                    
                    
                }
                .scrollContentBackground(.hidden)
                .foregroundColor(Color(hex: "#543C86"))
            }
        }.onAppear {
            print(UserTeams.teamConnections)
        }
        
    }
}
/*
 - Displays current connections and teams
 */
struct Connections: View {
    @State var moveToTeamDetailView = false
    @State var selectedTeam: Team = Team(people: [], teamID: "", emails: [],
                                         project: ProjectBuild(projectName: "",
                                                               description: "", teamSize: 0, projectType: ""))
    
    @EnvironmentObject var UserTeams: UserTeamData
    @EnvironmentObject var userModel: UserModel
    var body: some View {
        
        
        Section(header: Text("Connections")){
            if userModel.connections.count > 0 {
                ForEach(userModel.connections, id: \.self) { member in
                    VStack {
                        Text("\(member.name)")
                        Text("\(member.email)")
                    }.fontWeight(.regular)
                }
                .listRowBackground(Color.white)
            } else {
                Text("No Connections")
                    .fontWeight(.regular)
            }
        }.bold()
        // Fetches the users connection
        Section(header: Text("Teams")){
            if UserTeams.teamConnections.count > 0 {
                ForEach(UserTeams.teamConnections, id: \.teamID) { team in
                    VStack {
                        Text(team.project.projectName)
                            .fontWeight(.regular)
                    }
                    .onTapGesture {
                        moveToTeamDetailView = true
                        selectedTeam = team
                    }
                }
                .listRowBackground(Color.white)
                .navigationDestination(isPresented: $moveToTeamDetailView){
                    TeamDetailView(teamName: selectedTeam)
                        .environmentObject(userModel)
                }
            } else {
                Text("No Team Connections")
            }
        }.bold()
    }
}

/*
 - Displays recieved invites
 - User can reject/accept
 - Connections and teams accepted get
 addeed to connectionview
 */
struct RequestsView: View {
    // @Objects
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var UserTeams: UserTeamData
    @State var selectedTeam: Team = Team(people: [], teamID: "", emails: [], 
                                         project: ProjectBuild(
                                            projectName: "", description: "",
                                            teamSize: 0, projectType: ""))

    
    // Selected View
    @State var viewSelection = ""
    @State var moveToTeamDetailView = false
    var selectionOptions = ["Connections", "Requests"]
    
    
    var body: some View {
        // Display recieved requests
        Section(header: Text("Requests")){
            if userModel.requests.count > 0 {
                ForEach(userModel.requests.indices, id: \.self) { index in
                    let member = userModel.requests[index]
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(member.name)")
                            Text("\(member.email)")
                        }.fontWeight(.regular)
                        Spacer()
                        HStack(spacing: 20) {
                            Button(action: {
                                // API call to accept connection
                                Task {
                                    do {
                                        try await accpetUser(currUser: userModel.userID,
                                                             acceptUser: member.userID)
                                        
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
                                // API call to reject connection
                                Task {
                                    do {
                                        try await rejectUser(currUser: userModel.userID,
                                                             rejectedUser: member.userID)
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
                    .listRowBackground(Color.white)
                }
                .listRowBackground(Color.white)
            } else {
                Text("No Requests")
                    .fontWeight(.regular)
            }
        }.bold()
        Section(header: Text("Teams Requests")){
            if UserTeams.teamRequests.count > 0 {
                ForEach(UserTeams.teamRequests, id: \.teamID) { team in
                    HStack {
                        VStack {
                            Text(team.project.projectName).fontWeight(.regular)
                        }
                        .onTapGesture {
                            moveToTeamDetailView = true
                            selectedTeam = team
                        }
                        Spacer()
                        HStack(spacing: 20) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                                .onTapGesture {
                                    print("Clicked CheckMark")
                                    Task {
                                        // API call to accept/reject team invites
                                        do {
                                            try await acceptTeam(currUser: userModel.userID,
                                                                 teamID: team.teamID)
                                            
                                            try await UserTeams.hardCopy(userTeams:
                                                                        fetchCurrentUserTeam(currUser: userModel.userID))
                                        } catch {
                                            print(error)
                                        }
                                        
                                    }
                                }
                            
                            Spacer()
                            
                            Image(systemName: "xmark")
                                .foregroundColor(.red)
                                .onTapGesture {
                                    
                                    print("Clicked X")
                                    
                                    // Rejects and removes invite 
                                    Task {
                                        do {
                                            try await rejectTeam(currUser: userModel.userID, teamID: team.teamID)
                                        } catch {
                                            print(error)
                                        }
                                        
                                    }
                                    for element in UserTeams.teamRequests {
                                        if element == team {
                                            if let index = UserTeams.teamRequests.firstIndex(of: element) {
                                                UserTeams.teamRequests.remove(at: index)
                                            }
                                        }
                                    }
                                }
                            
                            
                        }
                    }
                }
                .listRowBackground(Color.white)
                .navigationDestination(isPresented: $moveToTeamDetailView){
                    TeamDetailView(teamName: selectedTeam)
                        .environmentObject(userModel)
                }.bold()
            } else {
                Text("No Requests")
                    .fontWeight(.regular)
            }
        }
    }
    
}
