//
//  FindMembersView.swift
//  GitGud
//
//  Created by Sajed Hussein on 2/26/24.
//

import Foundation
import SwiftUI



struct FindMembersView: View {
    @State private var isFindMembers: Bool = false
    @State var currentMember: [String?] = ["Find Member"]
    @State private var filteredList: [UserModel] = []
    @State var moveToTeamBuilderView = false
    @State var userList: [UserModel] = []
    @EnvironmentObject var userModel: UserModel
    @State var teamDescription: Team
    
    @State var aiResponse: [AiResponse]
    var experienceLevels: [String] = ["Medium", "Experienced", "Beginner"]
    
    
    //   @EnvironmentObject var userModel: UserModel
    
    
    // onappear change name if flag
    
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            List {
                ForEach(aiResponse.indices, id: \.self) { index in
                    // Access the element using the index
                    let member = $aiResponse[index] // Using $ to access the binding
                    
                    // Your code inside the ForEach loop
                    Section(header: Text("Member")
                        .foregroundColor(Color.text)
                        .font(.title3)) {
                            Picker("Experience Level:", selection: $aiResponse[index].experienceLevel) {
                                ForEach(experienceLevels, id: \.self) { level in
                                    Text(level)
                                }
                            }
                            TechStackEntryView(member: member) // Pass the binding
                            HStack {
                                Spacer()
                                Button(action: {
                                    let currentSkills: [String] = member.wrappedValue.skills // Accessing the wrapped value
                                    let currentExperienceLevel: String = member.wrappedValue.experienceLevel
                                    
                                    Task {
                                        do {
                                            filteredList = try await fetchFilteredList(skills: currentSkills, experienceLevel: currentExperienceLevel)
                                            
                                            print(filteredList)
                                            isFindMembers = true
                                        } catch {
                                            print(error)
                                        }
                                        
                                    }
                                }) {
                                    HStack {
                                        Text("Find Member")
                                        Image(systemName: "plus.magnifyingglass")
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
        .navigationDestination(isPresented: $isFindMembers) {
            MatchingView(userList: filteredList, TeamDescription: teamDescription, pickMember: true)
                .environmentObject(userModel)
        }
        
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $moveToTeamBuilderView, destination: {
            NavigationBar(userList: userList, selectedTab: "Team Builder")
            
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
        }
    }
}


struct TechStackEntryView: View {
    @Binding var member: AiResponse
    @State private var showingSkillsSelection = false
    
    
    
    // This view now presents a SelectionView when adding skills.
    var body: some View {
        VStack {
            
            Button("Add Skills") {
                showingSkillsSelection.toggle()
            }
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
            .foregroundColor(foregroundColor ?? (colorScheme == .dark ? .text : .text))
            .cornerRadius(30)
    }
}












