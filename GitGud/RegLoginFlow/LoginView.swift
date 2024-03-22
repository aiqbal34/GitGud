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

    
    
    
    var body: some View {
       NavigationStack {
            ZStack {
                GradientStyles.backgroundGradient
                    .edgesIgnoringSafeArea(.all)
                // A VStack with the Sign in Display and textfields
                VStack {
                    Text("Sign in")
                        .font(.system(size: 24))
                        .foregroundColor(.text)
                        .fontDesign(.monospaced)
                        .padding(.bottom)
                        .fontWeight(.bold)
                    HStack {
                        TextField("Email", text: $userName)
                            .frame(width: 200)
                            .foregroundColor(.text)
                            .fontDesign(.monospaced)
                            .focused($isKeyBoard)
                            .onAppear{
                                userName = ""
                            }
                    }
                    Rectangle()
                        .frame(width: 200, height: 2)
                        .foregroundColor(.text)
                        .padding(.bottom, 25)
            
                    SecureField("Password", text: $password)
                        .frame(width: 200)
                        .foregroundColor(.text)
                        .focused($isKeyBoard)
                        .textContentType(.password)
                        .onAppear{
                            password = ""
                        }

                    Rectangle()
                        .frame(width: 200, height: 2)
                        .foregroundColor(.text)
                        .padding(.bottom, 25)
                    
                    Button("Login") {
                        // this function allows the user to login using the userSignIn fucntion the Api file
                        Task {
                            do {
                                result = try await userSignIn(email: userName, password: password)
                                move_Home = true
                                UserDefaults.standard.set(result, forKey: "userID")
                            } catch let error as Error {
                                print(error.localizedDescription)
                                errorMessage = "Email/Password is Incorrect"
                            }
                        }
                    }
                    .frame(width: 200, height: 50)
                    .background(Color.secondaryBackground)
                    .foregroundColor(.text)
                    .fontDesign(.monospaced)
                    .cornerRadius(10)
                    .fontWeight(.bold)
                    .padding(.bottom)
                    
                    //Causes flag to set to true so user can move onto next step in registration process
                    Button("Create Account") {
                        move_Register = true
                        
                    }
                    .frame(width: 200, height: 50)
                    .background(Color.secondaryBackground)
                    .foregroundColor(.text)
                    .fontDesign(.monospaced)
                    .cornerRadius(10)
                    .fontWeight(.bold)
                    
                    Text(errorMessage)
                        .fontDesign(.monospaced)
                        .foregroundColor(.red)
                }
                
                .navigationDestination(isPresented: $move_Register){
                    RegisterView()
                        .environmentObject(userModel)
                }
                .navigationDestination(isPresented: $move_Home) {
                    LoadingView(currUserID: result ?? "", getData: true)
                }
                .navigationBarBackButtonHidden()
            }.onTapGesture {
                isKeyBoard = false
            }
            
        }
   }
}


#Preview {
    LoginView()
}
