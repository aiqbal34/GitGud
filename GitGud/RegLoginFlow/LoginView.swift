//
//  SwiftUIView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/24/24.
//

/*
 This is the Login Page for the User. The user can either login using their email and password or they create an account. If the user presses on create account logging in will take them to the next step in the account create process which is Register.View.
 */

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var userModel: UserModel
    @State var userName = ""
    @State var password = ""
    @FocusState var isKeyBoard: Bool
    @State var isLoggedin = false
    @State var move_Register = false
    @State var move_Home = false
    @State var result: String? = ""
    @State var errorMessage = ""
    @State var getData = true

    
    
    
    var body: some View {
       NavigationStack {
            ZStack {
                GradientStyles.backgroundGradient
                    .edgesIgnoringSafeArea(.all)
                // A VStack with the Sign in Display and textfields
                VStack {
                    Text("Sign in")
                        .font(.system(size: 24))
                        .foregroundColor(Color(hex: "#543C86"))
                        .fontDesign(.monospaced)
                        .padding(.bottom)
                        .fontWeight(.bold)
                    HStack {
                        TextField("Email", text: $userName)
                            .frame(width: 200)
                            .foregroundColor(Color(hex: "#543C86"))
                            .fontDesign(.monospaced)
                            .focused($isKeyBoard)
                            .onAppear{
                                userName = ""
                            }
                    }
                    Rectangle()
                        .frame(width: 200, height: 2)
                        .foregroundColor(Color(hex: "#543C86"))
                        .padding(.bottom, 25)
            
                    SecureField("Password", text: $password)
                        .frame(width: 200)
                        .foregroundColor(Color(hex: "#543C86"))
                        .focused($isKeyBoard)
                        .textContentType(.password)
                        .onAppear{
                            password = ""
                        }

                    Rectangle()
                        .frame(width: 200, height: 2)
                        .foregroundColor(Color(hex: "#543C86"))
                        .padding(.bottom, 25)
                    
                    Button("Login") {
                        Task {
                            do {
                                if let result = try await userSignIn(email: userName, password: password) {
                                    // Set the user ID in UserDefaults
                                    UserDefaults.standard.set(result, forKey: "userID")
                                    // Navigate to Home
                                    move_Home = true
                                } else {
                                    // Email not verified
                                    errorMessage = "Verify email to sign-in"
                                    getData = false
                                }
                            } catch {
                                // Handle errors
                                print(error.localizedDescription)
                                errorMessage = "Email/Password is Incorrect"
                            }
                        }
                    }

                    .frame(width: 200, height: 50)
                    .background(Color.white)
                    .foregroundColor(Color(hex: "#543C86"))
                    .fontDesign(.monospaced)
                    .cornerRadius(10)
                    .fontWeight(.bold)
                    .padding(.bottom)
                    
                    //Causes flag to set to true so user can move onto next step in registration process
                    Button("Create Account") {
                        move_Register = true
                        
                    }
                    .frame(width: 200, height: 50)
                    .background(Color.white)
                    .foregroundColor(Color(hex: "#543C86"))
                    .fontDesign(.monospaced)
                    .cornerRadius(10)
                    .fontWeight(.bold)
                    
                    Text(errorMessage)
                        .fontDesign(.monospaced)
                        .foregroundColor(.red)
                }
                
                .navigationDestination(isPresented: $move_Register){
                    NameMajorView()
                        .environmentObject(userModel)
                }
                .navigationDestination(isPresented: $move_Home) {
                    LoadingView(currUserID: result ?? "", getData: getData)
                }
                .navigationBarBackButtonHidden()
            }.onTapGesture {
                isKeyBoard = false
            }
            
        }
   }
}


//#Preview {
//    LoginView()
//}
