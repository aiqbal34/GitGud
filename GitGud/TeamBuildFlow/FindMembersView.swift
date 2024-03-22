//
//  FindMembersView.swift
//  GitGud
//
//  Created by Sajed Hussein on 2/26/24.
//

import Foundation
import SwiftUI
import LoadingButton

//Add the userTeamData here so the frontend can append that data

struct FindMembersView: View {
    @EnvironmentObject var foundMembers: FoundMembers
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var UserTeams: UserTeamData
    
    @State private var isFindMembers: Bool = false
    @State var currentMember: [String?] = ["Find Member"]
    @State private var filteredList: [UserModel] = []
    @State var moveToTeamBuilderView = false
    @State var userList: [UserModel] = []
    @State var teamDescription: Team
    @State var aiResponse: [AiResponse]
    @State var currentIndex: Int  = 0
    @State var imFeelingLucky: Bool
    
    var experienceLevels: [String] = ["Medium", "Experienced", "Beginner"]
   

    var body: some View {
        ZStack {
            GradientStyles.backgroundGradient
                .ignoresSafeArea()
            List {
                ForEach(aiResponse.indices, id: \.self) { index in
                    let member = $aiResponse[index]
                    
                    Section(header: Text("Member \(index + 1)")
                        .bold()
                        .foregroundColor(Color.text)
                        .font(.title3)) {
                            Picker("Experience Level:", selection: $aiResponse[index].experienceLevel) {
                                ForEach(experienceLevels, id: \.self) { level in
                                    Text(level)
                                }
                            }
                            if(!imFeelingLucky){
                                TechStackEntryView(member: member) // Pass the binding
                            }
                            HStack {
                                Spacer()
                                Button(action: {
                                    let currentSkills: [String] = member.wrappedValue.skills // Accessing the wrapped value
                                    let currentExperienceLevel: String = member.wrappedValue.experienceLevel
                                    
                                    Task {
                                        do {
                                            filteredList = try await fetchFilteredList(skills: currentSkills, experienceLevel: currentExperienceLevel)
                                            currentIndex = index
                                            print(filteredList)
                                            isFindMembers = true
                                        } catch {
                                            print(error)
                                        }
                                        
                                    }
                                }) {
                                    HStack {
                                        if let chosenMember = foundMembers.foundMembers[index] {
                                          Text("Chosen Member: \(chosenMember.name)")
                                                .foregroundColor(.black)
                                        } else {
                                          Text("Find Member ")
                                            Image(systemName: "plus.magnifyingglass")
                                        }
                                        
                                    }
                                }
                                Spacer()
                            }
                        }
                        .listRowBackground(Color.secondaryBackground)
                    
                    
                }
            }
            .scrollContentBackground(.hidden)
        }
        .onAppear {
            print(foundMembers.foundMembers)
        }
        .navigationDestination(isPresented: $isFindMembers) {
            MatchingView(userList: filteredList, TeamDescription: teamDescription, pickMember: true, currentMemberIndex: currentIndex)
                .environmentObject(userModel)
                .environmentObject(foundMembers)
        }
        
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $moveToTeamBuilderView, destination: {
            NavigationBar(userList: userList, selectedTab: "Team Builder")
                .environmentObject(userModel)
                .environmentObject(UserTeams)
            
        })
        
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button("Back") {
                    Task {
                        userList = try await fetchUsersForHomePage(currUser: userModel.userID)
                        moveToTeamBuilderView = true
                    }
                    
                }
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Finish") {
                    UserDefaults.standard.removeObject(forKey: "projectName")
                    UserDefaults.standard.removeObject(forKey: "projectDescription")
                    UserDefaults.standard.removeObject(forKey: "teamSize")
                    UserDefaults.standard.removeObject(forKey: "projectType")
                    do {
                        //change maybe, for now displays all the users, for which the guy has created
                        
                        Task {
                            try await createTeam(currUser: userModel.userID, teamDescription: teamDescription)
                            UserTeams.teamConnections.append(teamDescription)
                            for member in foundMembers.foundMembers {
                                try await sendTeamMatch(currUser: userModel.userID, sentUser: member?.userID ?? "", teamID: teamDescription.teamID)
                            }
                            userList = try await fetchUsersForHomePage(currUser: userModel.userID)
                            moveToTeamBuilderView = true
                        }
                        
                    }catch {
                        print(error)
                    }
                }
            }
        }
    }
}


struct TechStackEntryView: View {
    @Binding var member: AiResponse
    @State private var showingSkillsSelection = false
    
    
    
    // This view now presents a SelectionView when adding skills.
    var body: some View {
        VStack {
            Button("Add Skills +") {
                showingSkillsSelection.toggle()
            }
            .foregroundColor(.black)
            .sheet(isPresented: $showingSkillsSelection) {
                // Replace SkillsSelectionView with SelectionView for skill selection
                SearchViewModel(selectedItems: $member.skills, allItems: allSkills, itemLabel: { skill in
                    Text(skill)
                }, filterPredicate: { skill, searchText in
                    skill.lowercased().contains(searchText.lowercased())
                })
            }
            
            // Display selected skills remains unchanged
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(member.skills, id: \.self) { skill in
                        CustomBadge(label: skill)
                            
                    }
                }
            }
        }
    }
}





struct CustomBadge: View {
    @Environment(\.colorScheme) var colorScheme
    
    var label: String
    var backgroundColor: Color?
    var foregroundColor: Color?
    
    var body: some View {
        Text(label)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(Color.background)
            .foregroundColor(.white)
            .cornerRadius(30)
    }
}













