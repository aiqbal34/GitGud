//
//  RegisterView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/24/24.
//

//Test Comment

import SwiftUI

struct RegisterView: View {
    
    
    @EnvironmentObject var userModel: UserModel
    
    @State var email = ""
    @State var password = ""
    @State var reEnterpPssword = ""
    @FocusState var isKeyBoard: Bool
    
    @State var move_to_NameMajorView: Bool = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background)
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    Text("Create Account")
                        .font(.system(size: 24))
                        .foregroundColor(.text)
                        .fontDesign(.monospaced)
                        .padding(.bottom)
                        .fontWeight(.bold)
                    
                    TextField("Email", text: $email)
                        .frame(width: 200)
                        .foregroundColor(.text)
                        .fontDesign(.monospaced)
                        .focused($isKeyBoard)
                    
                    Rectangle()
                        .frame(width: 200, height: 2)
                        .foregroundColor(.text)
                        .padding(.bottom, 25)
                    
                    SecureField("Password", text: $password)
                        .frame(width: 200)
                        .foregroundColor(.text)
                        .focused($isKeyBoard)
                        .textContentType(.newPassword)
                    
                    Rectangle()
                        .frame(width: 200, height: 2)
                        .foregroundColor(.text)
                        .padding(.bottom, 25)
                    
                    SecureField("ReEnter Password", text: $reEnterpPssword)
                        .frame(width: 200)
                        .foregroundColor(.text)
                        .focused($isKeyBoard)
                        .textContentType(.password)
                    
                    
                    Rectangle()
                        .frame(width: 200, height: 2)
                        .foregroundColor(.text)
                        .padding(.bottom, 40)
                    Spacer()
                    HStack {
                        Spacer()
                        Button("Next") {
                            Task {
                                if password == reEnterpPssword && email.count != 0 {
                                    await create_Account(email: email, password: password)
                                }
                                userModel.email = email
                                move_to_NameMajorView = true
                            }
                        }
                        .padding(.trailing, 35)
                        .foregroundColor(.text)
                        .fontWeight(.bold)
                        
                    }
                    
                }
                
            }.onTapGesture {
                isKeyBoard = false
            }
            .navigationDestination(isPresented: $move_to_NameMajorView) {
                NameMajorView()
                    .environmentObject(userModel)
            }
        }
    }
}

