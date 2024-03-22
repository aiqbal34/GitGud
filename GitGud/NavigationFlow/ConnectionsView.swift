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
    @EnvironmentObject var UserTeams: UserTeamData
    
    var body: some View {
        
        ZStack {
            GradientStyles.backgroundGradient.ignoresSafeArea()
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
                .foregroundColor(Color.text)
            }
        }.onAppear {
            print(UserTeams.teamConnections)
        }
        
    }
}
struct Connections: View {
    @State var connections = ["Sally", "Bob", "Rob", "John"]
    @State var teamConnections = ["StartUp1", "HackathonTeam", "BestBuddies"]
    @State var moveToTeamDetailView = false
    @State var selectedTeam: Team = Team(people: [], teamID: "", emails: [], project: ProjectBuild(projectName: "", description: "", teamSize: 0, projectType: ""))
    
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
                .listRowBackground(Color.secondaryBackground)
            } else {
                Text("No Connections")
                    .fontWeight(.regular)
            }
        }.bold()
        
        Section(header: Text("Teams")){
            if UserTeams.teamConnections.count > 0 {
                ForEach(UserTeams.teamConnections, id: \.self) { team in
                    VStack {
                        Text(team.project.projectName)
                            .fontWeight(.regular)
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
        }.bold()
    }
}


struct TeamDetailView: View {
    var teamName: Team
    
    var body: some View {
        ZStack {
            GradientStyles.backgroundGradient.ignoresSafeArea()
            
            Spacer()
            VStack {
                List{
                    Section(header: Text("Emails:")){
                        ForEach(teamName.emails.indices, id: \.self) { index in
                            Text("\(teamName.emails[index])")
                                .foregroundColor(Color.text)
                                .font(.system(size: 14))
                                .lineSpacing(2) // Adjust line spacing as needed
                        }
                    }
                    Section(header: Text("People:")){
                        ForEach(teamName.people.indices, id: \.self) { index in
                            Text("\(teamName.people[index])")
                                .foregroundColor(Color.text)
                                .font(.system(size: 14))
                                .lineSpacing(2) // Adjust line spacing as needed
                        }
                    }
                    Section(header: Text("Project Description:")){
                        Text(teamName.project.description)
                            .foregroundColor(Color.text)
                            .font(.system(size: 16)) // Adjust font size for descriptions
                            .lineSpacing(4) // Adjust line spacing for descriptions
                            .multilineTextAlignment(.leading) // Align text to the left
                            .lineLimit(2)
                    }
                }
                .listRowBackground(Color.secondaryBackground)
                .foregroundColor(Color.text)
            }
        }
//        .foregroundColor(Color.text)
//        .accentColor(Color.text)
//        .ignoresSafeArea()
//        .navigationBarTitle(Text(teamName.project.projectName), displayMode: .inline)
    }
}

struct RequestsView: View {
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var UserTeams: UserTeamData
    @State var teamRequests = ["BestTeam", "TeamHackers", "Buddies"]
    @State var moveToTeamDetailView = false
    @State var selectedTeam: Team = Team(people: [], teamID: "", emails: [], project: ProjectBuild(projectName: "", description: "", teamSize: 0, projectType: ""))
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
                        }.fontWeight(.regular)
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
                    .fontWeight(.regular)
            }
        }.bold()
        //TODO
        Section(header: Text("Teams Requests")){
            if UserTeams.teamRequests.count > 0 {
                ForEach(UserTeams.teamRequests, id: \.self) { team in
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
                            Button(action: {
                                
                                Task {
                                    var reUser: UserModel
                                    do {
                                        try await acceptTeam(currUser: userModel.userID, teamID: team.teamID)
                                        reUser = try await fetchCurrentUsersInformation(urlString: "getCurrentUser" ,currUser: userModel.userID)
                                        try await UserTeams.hardCopy(userTeams: fetchCurrentUserTeam(currUser: userModel.userID))
                                        
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
                }.bold()
            } else {
                Text("No Requests")
                    .fontWeight(.regular)
            }
        }
    }
    
}


#Preview {
    ConnectionsView()
}
