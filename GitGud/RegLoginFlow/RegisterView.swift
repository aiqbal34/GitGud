//
//  RegisterView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/24/24.
//

/*
 This view is the first step in the account creation process. The user is prompted to enter their email and password they plan to use for the account. The User also has to reenter their password to ensure they typed it in correctly.
 */

import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject var userModel: UserModel
    //State variables that are passed into textfields
    @State var email = ""
    @State var password = ""
    @State var reEnterPassword = ""
    
    @FocusState var isKeyBoard: Bool
    @State var errorMessage = ""
    @State var move_to_verification: Bool = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientStyles.backgroundGradient.ignoresSafeArea()
                //The VStack which contains the Text and TextField prompting the User to enter their email and password
                VStack {
                    Text("Create Account")
                        .font(.system(size: 24))
                        .foregroundColor(Color(hex: "#543C86"))
                        .fontDesign(.monospaced)
                        .padding(.bottom)
                        .fontWeight(.bold)
                    
                    TextField("Email", text: $email)
                        .frame(width: 200)
                        .foregroundColor(Color(hex: "#543C86"))
                        .fontDesign(.monospaced)
                        .focused($isKeyBoard)
                    
                    Rectangle()
                        .frame(width: 200, height: 2)
                        .foregroundColor(Color(hex: "#543C86"))
                        .padding(.bottom, 25)
                    
                    SecureField("Password", text: $password)
                        .frame(width: 200)
                        .foregroundColor(Color(hex: "#543C86"))
                        .focused($isKeyBoard)
                        .textContentType(.newPassword)
                    
                    Rectangle()
                        .frame(width: 200, height: 2)
                        .foregroundColor(Color(hex: "#543C86"))
                        .padding(.bottom, 25)
                    
                    SecureField("ReEnter Password", text: $reEnterPassword)
                        .frame(width: 200)
                        .foregroundColor(Color(hex: "#543C86"))
                        .focused($isKeyBoard)
                        .textContentType(.password)
                    
                    
                    Rectangle()
                        .frame(width: 200, height: 2)
                        .foregroundColor(Color(hex: "#543C86"))
                        .padding(.bottom, 40)
                    
                    Text(errorMessage)
                        .fontDesign(.monospaced)
                        .foregroundColor(.red)
                    
                    
                    //Moves onto NameMajorView for next step in Creating an Account
                    Button("Create Account") {
                        Task {
                            //Check to see if the passwords and emailed entered are valid
                            if password == reEnterPassword && email.count != 0 && password.count != 0 && email.contains("@"){
                                do {
                                    // API call to create an account
                                    let result = try await create_Account(email: email, password: password)
                                    userModel.userID = result ?? ""
                                    userModel.email = email
                                    move_to_verification = true
                                } catch {
                                    print("Error: \(error)")
                                    errorMessage = "Error creating user: \(error.localizedDescription)"
                                }
                                
                            }
                            else{
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
                    .frame(width: 200, height: 50)
                    .background(Color.white)
                    .foregroundColor(Color(hex: "#543C86"))
                    .fontDesign(.monospaced)
                    .cornerRadius(10)
                    .fontWeight(.bold)
                }
                
            }.onTapGesture {
                isKeyBoard = false
            }
            .navigationDestination(isPresented: $move_to_verification) {
                EmailVerificationView(email: email, password: password)
                    .environmentObject(userModel)
            }
        }
    }
}

