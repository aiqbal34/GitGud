//
//  HomeMatchingView.swift
//  GitGud
//
//  Created by Sajed Hussein on 2/24/24.
//

import SwiftUI
import AlertToast

/*
 - Displays Users info/cards
 - User can match/next
 */

struct MatchingView: View {
    
    // @Objects
    @EnvironmentObject var userModel: UserModel
    @State var userList: [UserModel]
    @State var TeamDescription: Team?
    
    // @Navigation
    @State var pickMember: Bool
    @State private var getNext = false
    @State var bannerVisible: Bool = false
    
    // For the pickMembers part
    var currentMemberIndex: Int?
    @EnvironmentObject var foundMembers: FoundMembers
    @Environment(\.dismiss) var dismiss
    
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                GradientStyles.backgroundGradient
                    .ignoresSafeArea(.all)
                VStack{
                    // Displays users info via cards
                    UserCardView(userList: $userList)
                        .environmentObject(userModel)
                    
                    if !pickMember {
                        HStack{
                            // Sends a request to the user and removes him from stack
                            Button("Match") {
                                Task {
                                    let sentUser = UserModel()
                                    sentUser.hardCopy(user: userList[0]) //Copies the user from the list, overrides an error
                                    try await sendMatch(currUser: userModel.userID, sentUser: sentUser.userID) // Sends match request
                                    
                                    
                                }
                                bannerVisible = true
                                userList.removeFirst()
                            }
                            .bold()
                            .foregroundColor(Color.text)
                            .frame(width: 160, height: 64)
                            .background(Color.secondaryBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding()
                            
                            // Remove user from stack
                            Button("Next") {
                                userList.removeFirst()
                            }
                            .bold()
                            .foregroundColor(Color.secondaryBackground)
                            .frame(width: 160, height: 64)
                            .background(Color.background)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding()
                            
                            
                            
                            
                        }
                    }else {
                        HStack {
                            Group {
                                Button("Match") {
                                    Task {
                                        let sentUser = UserModel()
                                        sentUser.hardCopy(user: userList[0]) //Copies the user from the list, overrides an error
 
                                        
                                        bannerVisible = true
                                        userList.removeFirst()
                                        
                                        foundMembers.foundMembers[currentMemberIndex ?? 0] = sentUser
                                        
                                        dismiss()
                                        
                                    }
                                }
                                
                                Button("Next") {
                                    userList.removeFirst()
                                }
                                
                            }
                            .bold()
                            .foregroundColor(Color.text)
                            .frame(width: 160, height: 64)
                            .background(Color.background)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            
                        }
                    }
                    
                    
                }
            }
            
        }.toast(isPresenting: $bannerVisible){
            AlertToast(displayMode: .hud, type: .regular, title: "Match Sent")
            
        }
        
        
        .ignoresSafeArea(.all)
        .navigationBarBackButtonHidden(!pickMember)
        
    }
    
    
    // Bubble UI for skills
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
    
}
    
    
