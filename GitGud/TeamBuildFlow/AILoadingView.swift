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
    @EnvironmentObject var UserTeams: UserTeamData
    @State var aiResponse: [AiResponse] = []
    @State var foundMembers: FoundMembers = FoundMembers(foundMembers: [])
    @State var isError: Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                GradientStyles.backgroundGradient.ignoresSafeArea()
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

                            foundMembers.foundMembers = Array(repeating: nil, count: aiResponse.count)
                            pickMembersView = true
                        } catch {
                            print(error)
                            
                            isError = true
                            
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $pickMembersView){
                FindMembersView(teamDescription: Team(people: [userModel.name], teamID: projectBuild.projectName + String(generateRandomNumber()), emails: [userModel.email], project: projectBuild), aiResponse: aiResponse, imFeelingLucky: imFeelingLucky)
                    .environmentObject(userModel)
                    .environmentObject(foundMembers)
                    .environmentObject(UserTeams)
              
            }
            .navigationBarBackButtonHidden()
            .alert(isPresented: $isError) {
                Alert(title: Text("Welp"), message: Text("Something Went Wrong"), dismissButton: .default(Text("Cancel")))
            }
            .navigationDestination(isPresented: $isError) {
                TeamBuilderView()
                    .environmentObject(userModel)
                    .environmentObject(UserTeams)
            }
        }
    }
}

func generateRandomNumber() -> Int {
    return Int.random(in: 1...1000) // Generating a random number between 1 and 100
}
