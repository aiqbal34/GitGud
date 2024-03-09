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
                                .foregroundColor(Color.white)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top, 60)
                            
                            Spacer()
                            
                        }
                        
                        ScrollView{
                            HStack{
                                Image(systemName: "graduationcap.fill")
                                    .font(.system(size: 24))
                                Text(userList[0].university)
                                    .foregroundColor(Color.text)
                                    .font(.system(size: 24))
                                Spacer()
                            }
                            .padding()
                            
                            HStack{
                                Image(systemName: "book.fill")
                                    .font(.system(size: 24))
                                Text(userList[0].major)
                                    .foregroundColor(Color.text)
                                    .font(.system(size: 24))
                                Spacer()
                                
                            }
                            .padding()
                            HStack{
                                Image(systemName: "eyeglasses")
                                    .font(.system(size: 24))
                                Text(userList[0].experience)
                                    .foregroundColor(Color.text)
                                    .font(.system(size: 24))
                                Spacer()
                                
                            }
                            .padding()
                            HStack{
                                Image(systemName: "laptopcomputer")
                                    .font(.system(size: 24))
                                
                                Text("Tech Stack")
                                    .foregroundColor(Color.text)
                                    .font(.system(size: 24))
                                
                                Spacer()
                                
                            }
                            .padding()
                            
                            let gridItems = [GridItem(.adaptive(minimum: 100))]
                            LazyVGrid(columns: gridItems, spacing: 10) {
                                ForEach(userList[0].techStack , id: \.self) { skill in
                                    Text(skill)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .clipShape(Capsule())
                                }
                            }
                            .padding(.horizontal)
                            
                        }
                        .frame(width: 360,height: 450)
                        .background(Color.secondaryBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        
                        HStack{
                            Button("Match") {
                                Task {
                                    let sentUser = UserModel()
                                    sentUser.hardCopy(user: userList[0])
                                    try await sendMatch(currUser: userModel.userID, sentUser: sentUser.userID)
                                    userList.removeFirst()
                                    
                                }
                            }
                            .foregroundColor(Color.text)
                            .frame(width: 130, height: 64)
                            .background(Color.secondaryBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal)
                            
                            Button("Next") {
                                userList.removeFirst()
                            }
                            .foregroundColor(Color.text)
                            .frame(width: 130, height: 64)
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




