//
//  FindMembersView.swift
//  GitGud
//
//  Created by Sajed Hussein on 2/26/24.
//

import Foundation
import SwiftUI


enum ExpierenceLevel: String, CaseIterable, Identifiable {
    case Beginner, Intermidate, Advanced
    var id: Self { self }
}

struct FindMembersView: View {
    @ObservedObject var viewModel: TeamMembersViewModel
    @State private var isFindMembers: Bool = false

    
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
                        }
                        .listRowBackground(Color.secondaryBackground)
                    }
                    HStack{
                        Spacer()
                        Button("Find Members", action: { isFindMembers = true })
                            .frame(width: 260, height: 60, alignment: .center)
                            .background(Color.secondaryBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .navigationDestination(isPresented: $isFindMembers){
                                HomeMatchingView()
                            }
                        Spacer()
                    }
                    .listRowBackground(Color.background)
                    
                }
                
                .scrollContentBackground(.hidden)
                
                
            }
        }
    }
        
}

struct TechStackEntryView: View {
    @Binding var member: Member
    @State private var showingSkillsSelection = false

    private let allSkills = [
        "HTML", "CSS", "JavaScript", "React", "Angular", "Vue.js",
        "Python", "Java", "C++", "PHP", "Ruby", "Go", "Node.js",
        "Assembly Language", "Swift", "Kotlin", "C#", "Perl",
        "R", "Scala", "TypeScript", "Dart", "Haskell",
        "Bootstrap", "jQuery", "Express.js", "Django", "Spring",
        "Laravel", "TensorFlow", "PyTorch", "Keras",
        "Git", "Agile", "Waterfall", "Unit testing",
        "Integration testing", "APIs", "Web Services", "SQL",
        "NoSQL", "MySQL", "PostgreSQL", "MongoDB", "Oracle",
        "SQLite", "Cassandra", "CouchDB",
        "Docker", "Kubernetes", "Jenkins", "Ansible",
        "Heroku", "DigitalOcean", "Linode",
        "Software Design Patterns", "Formal Languages & Automata Theory",
        "Compiler Design", "Operating Systems Design", "Computer Architecture",
        "Distributed Systems", "Computer Graphics", "Human-Computer Interaction (HCI)",
        "Natural Language Processing (NLP)", "Computer Vision", "Robotics",
        "Software Engineering Principles",
        "User Research", "Usability Testing", "Information Architecture",
        "User Interface (UI) Design", "User Experience (UX) Writing", "Wireframing",
        "Prototyping", "Interaction Design", "Visual Design", "Accessibility",
        "UI/UX Design Tools (e.g., Figma, Adobe XD)", "User Empathy", "Usability Heuristics",
        "User Persona Development", "Card Sorting", "A/B Testing", "User Flows",
        "Design Thinking", "Iterative Design", "User Interface (UI) Patterns",
        "Microinteractions", "Visual Communication", "Color Theory", "Typography"
    ]


    var body: some View {
        VStack {

            Button("Add Skills") {
                showingSkillsSelection.toggle()
            }
            .sheet(isPresented: $showingSkillsSelection) {
                SkillsSelectionView(selectedSkills: $member.techStack, allSkills: allSkills)
            }

            // Display selected skills
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









struct Member {
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