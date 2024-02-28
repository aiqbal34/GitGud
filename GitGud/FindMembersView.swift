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
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all) // Make sure the color fills the entire screen
            
            Form {
                ForEach(0..<viewModel.members.count, id: \.self) { index in
                    Section(header: Text("Member \(index + 1)")) {
                        
                        Picker("Experience Level:", selection: $viewModel.members[index].experienceLevel) {
                            ForEach(ExpierenceLevel.allCases, id: \.self) { level in
                                Text(level.rawValue).tag(level)
                                
                            }
                        }
                        
                        // Tech Stack Entry and Display
                        TechStackEntryView(member: $viewModel.members[index])
                    }
                    .listRowBackground(Color.secondaryBackground)
                }
                Button("Find Members", action: { isFindMembers = true })
                    .frame(width: 260, height: 60)
                    .background(Color.secondaryBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                //.navigationDestination(isPresented: $pickMembersView){
                //    FindMembersView()
                //}
                
                
            }
            
        }
    }
}

struct TechStackEntryView: View {
    @Binding var member: Member
    @State private var newTech = ""
    
    var body: some View {
        HStack {
            TextField("Add Tech", text: $newTech)
            Button(action: {
                guard !newTech.isEmpty else { return }
                member.techStack.append(newTech)
                newTech = "" // Reset input field
            }) {
                Image(systemName: "plus.circle.fill")
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        
        // Display tech stack as bubbles
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(member.techStack, id: \.self) { tech in
                    Text(tech)
                        .padding(.horizontal)
                        .background(Circle().fill(Color.blue))
                        .foregroundColor(.white)
                }
            }
        }
        
    }
}








struct Member {
    var techStack: [String] = []
    var experienceLevel: ExpierenceLevel = .Beginner // Using enum for type safety
}

class TeamMembersViewModel: ObservableObject {
    @Published var members: [Member]
    
    init(numberOfMembers: Int) {
        // Initialize members with a default experience level
        self.members = Array(repeating: Member(), count: numberOfMembers)
    }
}









#Preview {
    FindMembersView(viewModel: TeamMembersViewModel(numberOfMembers: 2))
}




//"HTML", "CSS", "JavaScript", "React", "Angular", "Vue.js", "Python", "Java", "C++", "PHP", "Ruby", "Go", "Node.js",
//"Assembly Language", "Swift", "Kotlin", "C#", "Perl", "R", "Scala", "TypeScript", "Dart", "Haskell",
//"Bootstrap", "jQuery", "Express.js", "Django", "Spring", "Laravel", "TensorFlow", "PyTorch", "Keras",
//"Git", "Agile", "Waterfall", "Unit testing", "Integration testing", "APIs", "Web Services", "SQL", "NoSQL", "MySQL", "PostgreSQL", "MongoDB", "Oracle", "SQLite", "Cassandra", "CouchDB",
//
//"Docker", "Kubernetes", "Jenkins", "Ansible",
//"Heroku", "DigitalOcean", "Linode",
//"Software Design Patterns", "Formal Languages & Automata Theory", "Compiler Design", "Operating Systems Design", "Computer Architecture", "Distributed Systems", "Computer Graphics", "Human-Computer Interaction (HCI)", "Natural Language Processing (NLP)", "Computer Vision", "Robotics", "Software Engineering Principles"

//"User Research", "Usability Testing", "Information Architecture", "User Interface (UI) Design", "User Experience (UX) Writing", "Wireframing", "Prototyping", "Interaction Design", "Visual Design", "Accessibility", "UI/UX Design Tools (e.g., Figma, Adobe XD)", "User Empathy", "Usability Heuristics", "User Persona Development", "Card Sorting", "A/B Testing", "User Flows", "Design Thinking", "Iterative Design", "User Interface (UI) Patterns", "Microinteractions", "Visual Communication", "Color Theory", "Typography"
