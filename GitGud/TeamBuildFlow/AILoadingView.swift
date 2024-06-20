//
//  AILoadingView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 3/9/24.
//

import SwiftUI

/*
 - Generates skills based on description
 - On toggle, I'm feeling lucky, automates matching making
 - Fetches users and sorts them based on skills
 */

struct AILoadingView: View {
    
    // @Toggle to automate match making
    var imFeelingLucky: Bool
    
    // @Objects
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
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "#543C86")))
                    .scaleEffect(1.5)
                    .foregroundColor(Color(hex: "#543C86"))
                    .monospaced()
            }
            .onAppear{
                print(imFeelingLucky)
                // On toggle, automates match making view
                if imFeelingLucky {
                    Task {
                        aiResponse = try await sendReqToAiModel(description: projectBuild, urlString: "generateTeam")
                        for response in aiResponse {
                            // Fetches users and sorts them based on skills
                            let filteredList = try await fetchFilteredList(skills: response.skills, experienceLevel: response.experienceLevel)
                            // Assigns each members to the best fit
                            foundMembers.foundMembers.append(filteredList[0])
                        }
                        
                        pickMembersView = true
                    }
                }else {
                    // Manual match making
                    Task {
                        do {
                            
                            aiResponse = try await sendReqToAiModel(description: projectBuild, urlString: "generateTeam")
                            // Creates an array of sorted users to pick from
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
                FindMembersView(aiResponse: aiResponse, teamDescription: Team(people: [userModel.name:userModel.userID], teamID: projectBuild.projectName + String(generateRandomNumber()), emails: [userModel.email], project: projectBuild), imFeelingLucky: imFeelingLucky)
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
