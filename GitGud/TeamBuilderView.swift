//
//  TeamBuilderView.swift
//  GitGud
//
//  Created by Sajed Hussein on 2/25/24.
//

import Foundation
import SwiftUI


struct TeamBuilderView: View {
    
    @State private var projectName: String = ""
    @State private var projectType: String = ""
    @State private var projectDescription: String = ""
    @State private var teamSize: Int = 1
    
    @State private var pickMembersView: Bool = false
    
    var array: [String] = ["test 1", "test 2"] // Populate from back-end
    
    var body: some View {
        NavigationStack{
            VStack{
                ScrollView{
                    Text("Team Builder")
                        .foregroundColor(Color.text)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 80)
                    
                    Text("Project Name:")
                        .foregroundStyle(Color.text)
                        .font(.title2)
                        .lineLimit(1)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        .padding([.top, .horizontal])
                    
                    TextField("Enter Name", text: $projectName)
                        .padding()
                        .frame(width: 360, height: 50, alignment: .center)
                        .background(Color.secondaryBackground)
                        .cornerRadius(5)
                    
                    
                    Text("Project Type:")
                        .foregroundStyle(Color.text)
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .horizontal])
                    
                    Menu{
                        Button("Web app", action: { projectType = "Web app" })
                    } label: {
                        HStack{
                            Spacer()
                            Text(projectType)
                            Spacer()
                            Image(systemName:"chevron.down")
                        }
                        .padding()
                        .frame(width: 360, height: 50, alignment: .center)
                        .background(Color.secondaryBackground)
                        .cornerRadius(5)
                    }
                    
                    Text("Team Size:")
                        .foregroundStyle(Color.text)
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .horizontal])
                    
                    Menu{
                        Button("1", action: { teamSize = 1 })
                        Button("2", action: { teamSize = 2 })
                        Button("3", action: { teamSize = 3 })
                        Button("4", action: { teamSize = 4 })
                        Button("5", action: { teamSize = 5 })
                    } label: {
                        HStack{
                            Spacer()
                            Text(("\(teamSize)"))
                                .foregroundColor(Color.text)
                            Spacer()
                            Image(systemName:"chevron.down")
                        }
                        .padding()
                        .frame(width: 360, height: 50, alignment: .center)
                        .background(Color.secondaryBackground)
                        .cornerRadius(5)
                    }
                    
                    
                    Text("Project Description:")
                        .foregroundStyle(Color.text)
                        .font(.title2)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .horizontal])
                    
                    TextEditor(text: $projectDescription)
                        .foregroundColor(Color.text)
                        .font(.custom("HelveticaNeue", size: 14))
                        .lineSpacing(5)
                        .frame(width: 360, height: 125)
                        .background(Color.secondaryBackground)
                        .padding(4)
                        .cornerRadius(5)
                    
                    
                    Button("Find Members"){
                        Task {
                            let response = AiResponseString(projectName: projectName, response: projectDescription, teamSize: teamSize, projectType: projectType)
                            try await sendReqToAiModel(description: response, urlString: "generateTeam")
                            pickMembersView = true }
                    }
                    .frame(width: 260, height: 60)
                    .background(Color.secondaryBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top)
                    .navigationDestination(isPresented: $pickMembersView){
                        
                        FindMembersView(viewModel:
                                            TeamMembersViewModel(numberOfMembers: teamSize))
                    }
                    
                    
                    Spacer()
                    
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .ignoresSafeArea(.all)
                .background(Color.background)
                
            }
        }
    }
}





#Preview {
    TeamBuilderView()
}



