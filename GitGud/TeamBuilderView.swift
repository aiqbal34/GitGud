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
                
                Text("Team Builder")
                    .foregroundColor(Color.white)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 60)
                
                Text("Project Name:")
                    .foregroundStyle(Color.text)
                    .font(.title2)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.top, .horizontal])
                
                TextField("Enter Description", text: $projectDescription)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.secondaryBackground)
                    .cornerRadius(5)
                
                
                Group{
                    Text("Project Type:")
                        .foregroundStyle(Color.text)
                        .font(.title2)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .horizontal])
                    
                    Menu{
                        Button("Web app", action: { projectType = "Web app" })
                    } label: {
                        HStack{
                            Text(projectType)
                            Spacer()
                            Image(systemName:"chevron.down")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.secondaryBackground)
                        .cornerRadius(5)
                    }
                }
                
                Group{
                    Text("Team Size:")
                        .foregroundStyle(Color.text)
                        .font(.title2)
                        .lineLimit(1)
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
                            Text(("\(teamSize)"))
                            Spacer()
                            Image(systemName:"chevron.down")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.secondaryBackground)
                        .cornerRadius(5)
                    }
                }
                
                
                Text("Project Description:")
                    .foregroundStyle(Color.text)
                    .font(.title2)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.top, .horizontal])
                
                TextField("uuuu", text: $projectName)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .background(Color.secondaryBackground)
                    .cornerRadius(5)
                
                
                
                Button("Find Members", action: { pickMembersView = true })
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





#Preview {
    TeamBuilderView()
}



