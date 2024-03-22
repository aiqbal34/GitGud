//
//  RegisterView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/24/24.
//

import SwiftUI

struct RegisterView: View {
    
    
    @EnvironmentObject var userModel: UserModel
    
    @State var email = ""
    @State var password = ""
    @State var reEnterPassword = ""
    @FocusState var isKeyBoard: Bool
    @State var errorMessage = ""
    
    @State var move_to_NameMajorView: Bool = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientStyles.backgroundGradient.ignoresSafeArea()
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
                    
                    SecureField("ReEnter Password", text: $reEnterPassword)
                        .frame(width: 200)
                        .foregroundColor(.text)
                        .focused($isKeyBoard)
                        .textContentType(.password)
                    
                    
                    Rectangle()
                        .frame(width: 200, height: 2)
                        .foregroundColor(.text)
                        .padding(.bottom, 40)
                    
                    Text(errorMessage)
                        .fontDesign(.monospaced)
                        .foregroundColor(.red)
                        
                    
                    Spacer()
                    HStack {
                        Spacer()
                        //Moves onto NameMajorView for next step in Creating an Account
                        Button("Next") {
                            Task {
                                if password == reEnterPassword && email.count != 0 && password.count != 0 && email.contains("@"){
                                    do {
                                        let result = try await create_Account(email: email, password: password)
                                        print(result)
                                        userModel.userID = result ?? ""
                                        userModel.email = email
                                        move_to_NameMajorView = true
                                    }catch {
                                        print("Error as \(error)")
                                    }
                                }else{
                                    //Error Handling
                                    if email.count == 0{
                                        errorMessage = "Email is not entered"
                                    }
                                    else if email.contains("@") == false{
                                        errorMessage = "Not valid email"
                                    }
                                    else if password.count == 0{
                                        errorMessage = "Password is not entered"
                                    }
                                    else if password != reEnterPassword{
                                        errorMessage = "Passwords Don't Match"
                                    }
                                    
                                    
                                }
                                
                                
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

