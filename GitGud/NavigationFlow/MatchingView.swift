//
//  HomeMatchingView.swift
//  GitGud
//
//  Created by Sajed Hussein on 2/24/24.
//

import SwiftUI
import AlertToast



struct MatchingView: View {
    
    @EnvironmentObject var userModel: UserModel
    @State var userList: [UserModel]
    @State var TeamDescription: Team?
    @State var pickMember: Bool
    @State private var getNext = false
    @State var bannerVisible: Bool = false
    
    //For the pickMembers part
    var currentMemberIndex: Int?
    @EnvironmentObject var foundMembers: FoundMembers
    @Environment(\.dismiss) var dismiss
    
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    if (userList.count > 0) {
                        HStack {
                            Spacer()
                            
                            Circle()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.white)
                                .padding(.top, 60)
                            
                            Spacer()
                            
                            
                            Text(userList[0].name)
                                .font(.system(size: 45))
                                .foregroundColor(Color.text)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top, 60)
                            
                            Spacer()
                            
                        }
                        
                        List{
                            HStack{
                                Image(systemName: "graduationcap.fill")
                                    .font(.system(size: 24))
                                Text(userList[0].university)
                                    .foregroundColor(Color.text)
                                    .font(.system(size: 24))
                                Spacer()
                            }
                            .listRowBackground(Color.secondaryBackground)
                            .padding()
                            
                            HStack{
                                Image(systemName: "book.fill")
                                    .font(.system(size: 24))
                                Text(userList[0].major)
                                    .foregroundColor(Color.text)
                                    .font(.system(size: 24))
                                Spacer()
                                
                            }
                            .listRowBackground(Color.secondaryBackground)
                            .padding()
                            HStack{
                                Image(systemName: "eyeglasses")
                                    .font(.system(size: 24))
                                Text(userList[0].experience)
                                    .foregroundColor(Color.text)
                                    .font(.system(size: 24))
                                Spacer()
                                
                            }
                            .listRowBackground(Color.secondaryBackground)
                            .padding()
                            HStack{
                                Image(systemName: "laptopcomputer")
                                    .font(.system(size: 24))
                                
                                Text("Tech Stack")
                                    .foregroundColor(Color.text)
                                    .font(.system(size: 24))
                                
                                
                            }
                            .listRowBackground(Color.secondaryBackground)
                            .padding()
                            
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
                                ForEach(userList[0].techStack, id: \.self) { skill in
                                    SkillTagView(skill: skill)
                                }
                                
                            }
                            .listRowBackground(Color.secondaryBackground)
                            .padding()
                            
                        }
                        .scrollContentBackground(.hidden)
                        .frame(width: 400, height: 460)
                        
                        
                        
                        if !pickMember {
                            HStack{
                            
                                    Button("Match") {
                                        Task {
                                            let sentUser = UserModel()
                                            sentUser.hardCopy(user: userList[0]) //Copies the user from the list, overrides an error
                                            try await sendMatch(currUser: userModel.userID, sentUser: sentUser.userID)
                                            bannerVisible = true
                                            userList.removeFirst()
                                            
                                        }
                                    }
                                    .foregroundColor(Color.text)
                                    .frame(width: 160, height: 64)
                                    .background(Color.secondaryBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding()
                                
                                    Button("Next") {
                                        userList.removeFirst()
                                    }
                                    .foregroundColor(Color.secondaryBackground)
                                    .frame(width: 160, height: 64)
                                    .background(Color.text)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding()
                                    .border(Color.background, width: 4)
                            

                                
                            }
                        }else {
                            HStack {
                                Group {
                                    Button("Match") {
                                        Task {
                                            let sentUser = UserModel()
                                            sentUser.hardCopy(user: userList[0]) //Copies the user from the list, overrides an error
                                            let team = TeamDescription ?? Team(people: [],ids: [], emails: [], project: ProjectBuild(projectName: "", description: "", teamSize: 0, projectType: ""))
                                            try await sendTeamMatch(currUser: userModel.userID, sentUser: sentUser.userID, teamDescription: team)
                                            bannerVisible = true
                                            userList.removeFirst()
                                            
                                            foundMembers.foundMembers[currentMemberIndex ?? 0] = sentUser
                                            print(foundMembers)
                                            dismiss()
                                            
                                        }
                                    }
                                    
                                    Button("Next") {
                                        userList.removeFirst()
                                    }
                                    
                                }
                                .foregroundColor(Color.text)
                                .frame(width: 160, height: 64)
                                .background(Color.secondaryBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                

                            }
                        }
                        
                        Spacer()
                    } else {
                        Text("No more users")
                    }
                }
                
                
                
                
            }.toast(isPresenting: $bannerVisible){
                AlertToast(displayMode: .hud, type: .regular, title: "Match Sent")
                
            }
            
            
            .ignoresSafeArea(.all)
            .background(Color.background)
            .navigationBarBackButtonHidden(!pickMember)
            
        }
        
    }
}


struct SkillTagView: View {
    var skill: String
    
    var body: some View {
        Text(skill)
            .font(.system(size: 16))
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .background(Capsule().fill(Color.gray.opacity(0.2)))
            .overlay(
                Capsule().strokeBorder(Color.gray, lineWidth: 0.5)
            )
    }
}




