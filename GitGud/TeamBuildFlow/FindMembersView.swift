//
//  FindMembersView.swift
//  GitGud
//
//  Created by Sajed Hussein on 2/26/24.
//

import Foundation
import SwiftUI
import LoadingButton

/*
    - User matches with one person for each
        role to create team
    - List of users is sorted
    - Can Add skills to each role
 */
struct FindMembersView: View {
    // @Objects
    @EnvironmentObject var foundMembers: FoundMembers
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var UserTeams: UserTeamData
    
    @State var aiResponse: [AiResponse]
    @State private var isFindMembers: Bool = false
    @State var currentMember: [String?] = ["Find Member"]
    @State private var filteredList: [UserModel] = []
    @State var moveToTeamBuilderView = false
    @State var userList: [UserModel] = []
    @State var teamDescription: Team
    @State var currentIndex: Int  = 0
    @State var imFeelingLucky: Bool
    
    var experienceLevels: [String] = [ "Beginner", "Medium", "Experienced",]
   

    var body: some View {
        ZStack {
            GradientStyles.backgroundGradient
                .ignoresSafeArea()
            List {
                // Based on backend call to gpt
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
                                // Display generated skills
                                TechStackEntryView(member: member)
                            }
                            HStack {
                                Spacer()
                                Button(action: {
                                    let currentSkills: [String] = member.wrappedValue.skills
                                    let currentExperienceLevel: String = member.wrappedValue.experienceLevel
                                    
                                    Task {
                                        do {
                                            // Fecthes users list sorted by compatiblity based on skills
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
                                        // Display chosen member
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
            // Navigate to MatchingView to display list of users
            MatchingView(userList: filteredList, TeamDescription: teamDescription,
                         pickMember: true, currentMemberIndex: currentIndex)
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
            // Custom Back button
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
                        
                        Task {
                            // Creates team and addes it to connections
                            try await createTeam(currUser: userModel.userID, teamDescription: teamDescription)
                            UserTeams.teamConnections.append(teamDescription)
                            for member in foundMembers.foundMembers {
                                try await sendTeamMatch(currUser: userModel.userID, sentUser: member?.userID ?? "", teamID: teamDescription.teamID)
                            }
                            // Populates homeView again
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

/*
    - Displays skills
    - Allows user to add skills via search
 */

struct TechStackEntryView: View {
    @Binding var member: AiResponse
    @State private var showingSkillsSelection = false
    
    
    var body: some View {
        VStack {
            Button("Add Skills +") {
                showingSkillsSelection.toggle()
            }
            .foregroundColor(.black)
            .sheet(isPresented: $showingSkillsSelection) {
                // Skill searching functionality, pop up sheet
                SearchViewModel(selectedItems: $member.skills, allItems: allSkills, itemLabel: { skill in
                    Text(skill)
                }, filterPredicate: { skill, searchText in
                    skill.lowercased().contains(searchText.lowercased())
                })
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    // Creates bubbles UI
                    ForEach(member.skills, id: \.self) { skill in
                        CustomBadge(label: skill)
                            
                    }
                }
            }
        }
    }
}



/*
 - Custom UI for skills bubbles in this view
 */

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













