//
//  TeamBuilderView.swift
//  GitGud
//
//  Created by Sajed Hussein on 2/25/24.
//

import Foundation
import SwiftUI


struct TeamBuilderView: View {
    
    @State private var imFeelingLucky: Bool = true
    @State private var projectName: String = ""
    @State private var projectDescription: String = ""
    @State private var teamSize: Int = 1
    @State var chosenProjectType = "Choose Project Type"
    @State var showProjectType = false
    @State var move_toAiLosingView: Bool = false
    @State var project: ProjectBuild = ProjectBuild(projectName: "", description: "", teamSize: 0, projectType: "")
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var UserTeams: UserTeamData
    
    
    
    var projectTypeArray = ["Web App", "IOS App", "Andriod App"]
    
    @State var isError = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                GradientStyles.backgroundGradient
                    .ignoresSafeArea()
                ScrollView{
                    VStack{
                        
                        Text("Team Builder")
                            .foregroundColor(Color.text)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 80)
                        
                        Toggle("I'm Feeling Lucky", isOn: $imFeelingLucky)
                            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                            .frame(width: 200)
                            .bold()
                        Text("Project Name:")
                            .bold()
                            .foregroundStyle(Color.text)
                            .font(.title2)
                            .lineLimit(1)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                            .padding([.top, .horizontal])
                        
                        TextField("Enter Name", text: $projectName)
                            .padding()
                            .frame(width: 360, height: 50, alignment: .center)
                            .background(Color.secondaryBackground)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.text, lineWidth: 1)
                            )
                        
                        
                        Text("Project Type:")
                            .bold()
                            .foregroundStyle(Color.text)
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.top, .horizontal])
                        
                        Button(chosenProjectType) {
                            showProjectType.toggle()
                        }.sheet(isPresented: $showProjectType, content: {
                            SearchSingleViewModel(allItems: projectTypeArray, itemLabel: {
                                projecttype in Text(projecttype).onTapGesture {
                                    showProjectType = false
                                    print(projecttype)
                                    chosenProjectType = projecttype
                                }
                            }, filterPredicate: { projecttype, searchText in
                                projecttype.lowercased().contains(searchText.lowercased())
                            })
                        })
                        .frame(width: 360, height: 50)
                        .background(Color.secondaryBackground)
                        .foregroundColor(.text)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.text, lineWidth: 1)
                        )
                        .fontWeight(.bold)
                        
                        Text("Team Size:")
                            .bold()
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
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.text, lineWidth: 1)
                            )
                        }
                        
                        Text("Project Description:")
                            .bold()
                            .foregroundStyle(Color.text)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.top, .horizontal])
                            .font(.title3)
                        
                        TextEditor(text: $projectDescription)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .foregroundColor(Color.text)
                            .font(.custom("HelveticaNeue", size: 14))
                            .lineSpacing(5)
                            .frame(width: 360, height: 125)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.text, lineWidth: 1)
                            )
                        
                        
                        
                        if (isError) {
                            Text("Please fill all the fields before moving on")
                                .foregroundStyle(Color.red)
                                .monospaced()
                                .font(.custom("HelveticaNeue", size: 10))
                        }

                        
                        
                        Button("Find Members"){
                            
                            Task {
                                if !projectName.isEmpty && !projectDescription.isEmpty && teamSize > 0 && chosenProjectType != "Choose Project Type" {
                                    project = ProjectBuild(projectName: projectName, description: projectDescription, teamSize: teamSize, projectType: chosenProjectType)
                                    UserDefaults.standard.set(projectName, forKey: "projectName")
                                    UserDefaults.standard.set(projectDescription, forKey: "projectDescription")
                                    UserDefaults.standard.set(teamSize, forKey: "teamSize")
                                    UserDefaults.standard.set(chosenProjectType, forKey: "projectType")
                                    move_toAiLosingView = true
                                } else {
                                    isError = true
                                }
                            }
                        }
                        .bold()
                        .frame(width: 260, height: 60)
                        .background(Color.secondaryBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.text, lineWidth: 1)
                        )
                    
                        Spacer()
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .ignoresSafeArea(.all)
                .navigationDestination(isPresented: $move_toAiLosingView){
                    AILoadingView(imFeelingLucky: imFeelingLucky, projectBuild: project)
                        .environmentObject(userModel)
                        .environmentObject(UserTeams)
                    
                }
                
            }.onAppear {
                if let savedProjectName = UserDefaults.standard.string(forKey: "projectName") {
                    projectName = savedProjectName
                } else {
                    projectName = "" // Or set a default value
                }

                if let savedProjectDescription = UserDefaults.standard.string(forKey: "projectDescription") {
                    projectDescription = savedProjectDescription
                } else {
                    projectDescription = "" // Or set a default value
                }

                // Use integer(forKey:) for teamSize and string(forKey:) for projectType
                if UserDefaults.standard.object(forKey: "teamSize") != nil {
                  teamSize = UserDefaults.standard.integer(forKey: "teamSize")
                } else {
                  teamSize = 1 // Or set a default value
                }
                if let savedProjectType = UserDefaults.standard.string(forKey: "projectType") {
                    chosenProjectType = savedProjectType
                } else {
                    chosenProjectType = "Choose Project Type" // Or set a default value
                }
            }
        }
    }
}






#Preview {
    TeamBuilderView()
}



