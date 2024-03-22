//
//  UserCardView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 3/13/24.
//

import SwiftUI

struct UserCardView: View {
    
    @EnvironmentObject var userModel: UserModel
    @Binding var userList: [UserModel]
    var body: some View {
        if (userList.count > 0) {
            HStack {
                Spacer()
                Text(userList[0].name)
                    .font(.system(size: 45))
                    .foregroundColor(Color.text)
                    .bold()
                
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
                
                LazyVGrid(columns: [GridItem(.fixed(120))], spacing: 8) { // Replace 120 with your desired width
                    ForEach(userList[0].techStack, id: \.self) { skill in
                        CustomBadge(label: skill)
                    }
                }
                .listRowBackground(Color.secondaryBackground)
                .padding()
                
            }
            .scrollContentBackground(.hidden)
            .frame(width: 400, height: 460, alignment: .bottomTrailing)
        }
    }
}

