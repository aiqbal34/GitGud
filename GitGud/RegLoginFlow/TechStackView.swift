//
//  TechStackView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/26/24.
//

import SwiftUI

/*
 - Prompts user to enter skills
 - Pop-up seach menu
 */
struct TechStackView: View {
    
    // @Objects
    @EnvironmentObject var userModel: UserModel
    
    @State var move_to_PhoneInputView = false
    @State var experience = ""
    
    // Predefined list of experience levels
    var experienceLevels = ["Beginner", "Medium" ," Experienced"]
    

    @State var showSkillSheet = false
    @State var chosenSkills: [String] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientStyles.backgroundGradient.ignoresSafeArea()
                VStack {
                    Spacer()
                    
                    Text("Create Profile")
                        .font(.system(size: 24))
                        .foregroundColor(.text)
                        .fontDesign(.monospaced)
                        .padding(.bottom)
                        .fontWeight(.bold)
                    
                    Text("Select Expereince")
                        .font(.system(size: 18))
                        .foregroundColor(.text)
                        .fontDesign(.monospaced)
                        .padding(.top)
                        .fontWeight(.bold)
                    
                    Picker("Select Experience", selection: $experience) {
                        ForEach(experienceLevels, id: \.self) { item in
                            Text(item)
                                .foregroundColor(.blue)
                                .font(.headline)
                                .padding()
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .background(Color.secondaryBackground)
                    .cornerRadius(10)
                    .frame(height: 100)
                    
                    // Appends skills to the user
                    Button("Choose Skills") {
                        showSkillSheet.toggle()
                    }.sheet(isPresented: $showSkillSheet, content: {
                        // Pop-up search menu
                        SearchViewModel(selectedItems: $chosenSkills, allItems: allSkills, itemLabel: { skill in
                            Text(skill)
                        }, filterPredicate: { skill, searchText in
                            skill.lowercased().contains(searchText.lowercased())
                        })
                    })
                    .frame(width: 200, height: 50)
                    .background(Color.secondaryBackground)
                    .foregroundColor(.text)
                    .fontDesign(.monospaced)
                    .cornerRadius(10)
                    .fontWeight(.bold)
                    .padding(.bottom)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                        ForEach(chosenSkills, id: \.self) { skill in
                            Text(skill)
                                .padding()
                                .background(Color.secondaryBackground)
                                .foregroundColor(.text)
                                .fontDesign(.monospaced)
                                .clipShape(Capsule())
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Button("Next") {
                            if chosenSkills != [] && experience != "" {
                                userModel.experience = experience
                                userModel.techStack = chosenSkills
                                move_to_PhoneInputView = true
                            }
                        }
                        .padding(.trailing, 35)
                        .padding(.top, 25)
                        .foregroundColor(.text)
                        .fontWeight(.bold)
                        
                    }
                }
                
            }
            .navigationDestination(isPresented: $move_to_PhoneInputView) {
                PhoneInputView().environmentObject(userModel)
            }
        }
    }
}
