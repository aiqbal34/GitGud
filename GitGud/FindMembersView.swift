//
//  FindMembersView.swift
//  GitGud
//
//  Created by Sajed Hussein on 2/26/24.
//

import Foundation
import SwiftUI


enum ExpierenceLevel: String, CaseIterable, Identifiable, Encodable {
    case Beginner, Intermidate, Advanced
    var id: Self { self }
}

struct FindMembersView: View {
    @ObservedObject var viewModel: TeamMembersViewModel
    @State private var isFindMembers: Bool = false
    @State var currentMember: [String?] = ["Find Member"]
    @State private var filteredList: [UserModel] = []
    
    
    // onappear change name if flag
    
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                List {
                    ForEach(0..<viewModel.members.count, id: \.self) { index in
                        Section(header: Text("Member \(index + 1)")
                            .foregroundColor(Color.text)
                            .font(.title3)) {
                                
                                Picker("Experience Level:", selection: $viewModel.members[index].experienceLevel) {
                                    ForEach(ExpierenceLevel.allCases, id: \.self) { level in
                                        Text(level.rawValue).tag(level)
                                        
                                    }
                                }
                                
                                TechStackEntryView(member: $viewModel.members[index])
                                HStack{
                                    Spacer()
                                    Button("Find Member \(Image.init(systemName: "plus.magnifyingglass"))") {
                                        let currentSkills = viewModel.members[index].techStack
                                        let currentExperienceLevel = viewModel.members[index].experienceLevel.rawValue
                                        
    
                                        Task {
                                            do {
                                                filteredList = try await fetchFilteredList(skills: currentSkills, experienceLevel: currentExperienceLevel)
                                                isFindMembers = true
                                            } catch {
                                                print(error)
                                            }
                                        }
                                    }
                                    .navigationDestination(isPresented: $isFindMembers){
                                        HomeMatchingView(userList: filteredList)
                                            .environmentObject(UserModel())
                                    }
                                    Spacer()
                                }
                                
                            }
                            .listRowBackground(Color.secondaryBackground)
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
    }
    
}

struct TechStackEntryView: View {
    @Binding var member: Member
    @State private var showingSkillsSelection = false
    
    
    
    // This view now presents a SelectionView when adding skills.
    var body: some View {
        VStack {
            
            Button("Add Skills") {
                showingSkillsSelection.toggle()
            }
            .sheet(isPresented: $showingSkillsSelection) {
                // Replace SkillsSelectionView with SelectionView for skill selection
                SelectionView(selectedItems: $member.techStack, allItems: allSkills, itemLabel: { skill in
                    Text(skill)
                }, filterPredicate: { skill, searchText in
                    skill.lowercased().contains(searchText.lowercased())
                })
            }
            
            // Display selected skills remains unchanged
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(member.techStack, id: \.self) { skill in
                        Text(skill)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }
}










struct Member: Encodable {
    var techStack: [String] = []
    var experienceLevel: ExpierenceLevel = .Beginner
}

class TeamMembersViewModel: ObservableObject {
    @Published var members: [Member]
    
    init(numberOfMembers: Int) {
        self.members = Array(repeating: Member(), count: numberOfMembers)
    }
}









#Preview {
    FindMembersView(viewModel: TeamMembersViewModel(numberOfMembers: 2))
}
