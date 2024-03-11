//
//  HomeMatchingView.swift
//  GitGud
//
//  Created by Sajed Hussein on 2/24/24.
//

import SwiftUI



struct HomeMatchingView: View {
    
    @EnvironmentObject var userModel: UserModel
    @State var userList: [UserModel]
    
    @State private var getNext = false
    
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
                        
                        
                        
                        
                        HStack{
                            Button("Match") {
                                Task {
                                    let sentUser = UserModel()
                                    sentUser.hardCopy(user: userList[0]) //Copies the user from the list, overrides an error
                                    try await sendMatch(currUser: userModel.userID, sentUser: sentUser.userID)
                                    userList.removeFirst()
                                    
                                }
                            }
                            .foregroundColor(Color.text)
                            .frame(width: 160, height: 64)
                            .background(Color.secondaryBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal)
                            
                            Button("Next") {
                                userList.removeFirst()
                            }
                            .foregroundColor(Color.text)
                            .frame(width: 160, height: 64)
                            .background(Color.secondaryBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding()
                            
                        }
                        
                        
                        Spacer()
                    } else {
                        Text("No more users")
                    }
                }
                
                
            }
            .ignoresSafeArea(.all)
            .background(Color.background)
            .navigationBarBackButtonHidden()
            
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




