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
    @State private var projectDescription: String = ""
    @State private var teamSize: Int = 1
    
    @State var chosenProjectType = "Choose Project Type"
    @State var showProjectType = false
    
    @State var move_toAiLosingView: Bool = false
    
    @State var project: ProjectBuild = ProjectBuild(projectName: "", description: "", teamSize: 0, projectType: "")
    @EnvironmentObject var userModel: UserModel
    
    
    
    var projectTypeArray = ["Web App", "IOS App", "Andriod App"]
    
    @State var isError = false
    
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
                    
                    Button(chosenProjectType) {
                        showProjectType.toggle()
                    }.sheet(isPresented: $showProjectType, content: {
                        SelectionViewSingleItem(allItems: projectTypeArray, itemLabel: {
                            projecttype in Text(projecttype).onTapGesture {
                                showProjectType = false
                                print(projecttype)
                                chosenProjectType = projecttype
                            }
                        }, filterPredicate: { projecttype, searchText in
                            projecttype.lowercased().contains(searchText.lowercased())
                        })
                    })
                    .frame(width: 200, height: 50)
                    .background(Color.secondaryBackground)
                    .foregroundColor(.text)
                    .fontDesign(.monospaced)
                    .cornerRadius(10)
                    .fontWeight(.bold)
                  
                    
                    
                    
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
                                move_toAiLosingView = true
                            } else {
                               isError = true
                            }
                        }
                    }
                    .frame(width: 260, height: 60)
                    .background(Color.secondaryBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top)

                    
                    
                    Spacer()
                    
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .ignoresSafeArea(.all)
                .background(Color.background)
                
                
                .navigationDestination(isPresented: $move_toAiLosingView){
                    AILoadingView(projectBuild: project)
                        .environmentObject(userModel)
                     
                }
            }
        }
    }
}





#Preview {
    TeamBuilderView()
}



