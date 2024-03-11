//
//  SwiftUIView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/24/24.
//

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
    
    var body: some View {
       NavigationStack {
            ZStack {
                Color(.background)
                    .ignoresSafeArea()
                VStack {
                    Text("Sign in")
                        .font(.system(size: 24))
                        .foregroundColor(.text)
                        .fontDesign(.monospaced)
                        .padding(.bottom)
                        .fontWeight(.bold)
                    HStack {
                        TextField("Username", text: $userName)
                            .frame(width: 200)
                            .foregroundColor(.text)
                            .fontDesign(.monospaced)
                            .focused($isKeyBoard)
                    }
                    Rectangle()
                        .frame(width: 200, height: 2)
                        .foregroundColor(.text)
                        .padding(.bottom)
            
                        SecureField("Password", text: $password)
                            .frame(width: 200)
                            .foregroundColor(.text)
                            .fontDesign(.monospaced)
                            .focused($isKeyBoard)
                            .textContentType(.password)

                    Rectangle()
                        .frame(width: 200, height: 2)
                        .foregroundColor(.text)
                        .padding(.bottom, 40)
                    Button("Login") {
                        // this function allows the user to login is in the api file
                        
                        Task {
                            do {
                                 result = try await userSignIn(email: userName, password: password)
                                
                                move_Home = true
                            } catch let error as Error {
                                print(error.localizedDescription)
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
                    
                    Button("Create Account") {
                        move_Register = true
                        
                    }
                    .frame(width: 200, height: 50)
                    .background(Color.secondaryBackground)
                    .foregroundColor(.text)
                    .fontDesign(.monospaced)
                    .cornerRadius(10)
                    .fontWeight(.bold)
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
