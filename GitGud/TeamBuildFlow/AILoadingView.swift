//
//  AILoadingView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 3/9/24.
//

import SwiftUI

struct AILoadingView: View {
    
    var imFeelingLucky: Bool
    
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
                print(imFeelingLucky)
                if imFeelingLucky {
                    Task {
                        aiResponse = try await sendReqToAiModel(description: projectBuild, urlString: "generateTeam")
                        for response in aiResponse {
                            var filteredList = try await fetchFilteredList(skills: response.skills, experienceLevel: response.experienceLevel)
                            foundMembers.foundMembers.append(filteredList[0])
                        }
        
                        pickMembersView = true
                    }
                }else {
                    Task {
                        do {
                            aiResponse = try await sendReqToAiModel(description: projectBuild, urlString: "generateTeam")
                            
                            userModel.teamConnections.append(Team(people: [userModel.name],ids: [userModel.userID], emails: [userModel.email], project: projectBuild))
                            foundMembers.foundMembers = Array(repeating: nil, count: aiResponse.count)
                            
                        } catch {
                            print(error)
                        }
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

