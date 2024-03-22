//
//  AILoadingView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 3/9/24.
//

import SwiftUI

/*
 - Loading Screen -> FindMemebersView:
     - Calls the backend to generate
        skills based on description via gpt
     - On "I'm feeling lucky" generates matches
        for the team (automates matches)
 */
struct AILoadingView: View {
    
    // Toggle for automatching
    var imFeelingLucky: Bool
    
    // @Objects
    var projectBuild: ProjectBuild
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var UserTeams: UserTeamData
    @State var aiResponse: [AiResponse] = []
    @State var foundMembers: FoundMembers = FoundMembers(foundMembers: [])
    
    // Navigation Conrol
    @State var isError: Bool = false
    @State var pickMembersView = false
    
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
                // AutoMate match making
                if imFeelingLucky {
                    Task {
                        // Generates skills for each based on description
                        aiResponse = try await sendReqToAiModel(description: projectBuild, urlString: "generateTeam")
                        for response in aiResponse {
                            // Fetches users and sorts based on compatibility
                            let filteredList = try await fetchFilteredList(skills: response.skills, 
                                                                           experienceLevel: response.experienceLevel)
                            // Matches with the best pick based on sorted list
                            foundMembers.foundMembers.append(filteredList[0])
                        }
                        
                        pickMembersView = true
                    }
                }else {
                    // Manual Matching Making
                    Task {
                        do {
                            // Generates skills for each based on description
                            aiResponse = try await sendReqToAiModel(description: projectBuild, 
                                                                    urlString: "generateTeam")
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
                // Navigates to FindMembersView
                FindMembersView(teamDescription: Team(people: [userModel.name], teamID: projectBuild.projectName
                                                      + String(generateRandomNumber()),
                                                      emails: [userModel.email], project: projectBuild),
                                                    aiResponse: aiResponse, imFeelingLucky: imFeelingLucky)
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
