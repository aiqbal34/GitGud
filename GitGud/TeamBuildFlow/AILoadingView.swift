//
//  AILoadingView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 3/9/24.
//

import SwiftUI

struct AILoadingView: View {
    
    var projectBuild: ProjectBuild
    
    @State var pickMembersView = false
    @EnvironmentObject var userModel: UserModel
    @State var aiResponse: [AiResponse] = []
    @State var foundMembers: FoundMembers = FoundMembers(foundMembers: [])
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background).ignoresSafeArea()
                ProgressView("Loading…", value: 0.99)
                    .progressViewStyle(CircularProgressViewStyle(tint: .text))
                    .scaleEffect(1.5)
                    .foregroundColor(.text)
                    .monospaced()
            }
            .onAppear{
                
                Task {
                    do {
                        aiResponse = try await sendReqToAiModel(description: projectBuild, urlString: "generateTeam")
                        try await createTeam(currUser: userModel.userID, teamDescription: Team(people: [], ids: [], emails: [], project: projectBuild))
                        userModel.teamConnections.append(Team(people: [userModel.name],ids: [userModel.userID], emails: [userModel.email], project: projectBuild))
                        foundMembers.foundMembers = Array(repeating: nil, count: aiResponse.count)
                        pickMembersView = true
                    } catch {
                        print(error)
                    }
                }
            }
            .navigationDestination(isPresented: $pickMembersView){
                FindMembersView(teamDescription: Team(people: [userModel.name],ids: [userModel.userID], emails: [userModel.email], project: projectBuild), aiResponse: aiResponse)
                    .environmentObject(userModel)
                    .environmentObject(foundMembers)
              
            }
            .navigationBarBackButtonHidden()
        }
    }
}

