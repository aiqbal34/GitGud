//
//  SwiftUIView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/24/24.
//

import SwiftUI

struct LoginView: View {
    
    
    
    @State var userName = ""
    @State var password = ""
    @FocusState var isKeyBoard: Bool
    
    @State var move_Register = false
    
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
                    HStack {
                        TextField("Password", text: $password)
                            .frame(width: 200)
                            .foregroundColor(.text)
                            .fontDesign(.monospaced)
                            .focused($isKeyBoard)
                    }
                    Rectangle()
                        .frame(width: 200, height: 2)
                        .foregroundColor(.text)
                        .padding(.bottom, 40)
                    Button("Login") {
                        Task {
                            do {
                                try await userSignIn(email: userName, password: password)
                            } catch let error as Error {
                                print(error)
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
                        create_Account(email: userName, password: password)
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
                }
            }.onTapGesture {
                isKeyBoard = false
            }
            .onAppear {
                Task {
                    do {
                        let response = try await fetchData()
                        print(response)
                    } catch let urlerror as URLError {
                        print(urlerror)
                    }
                }
            }
        }
    }
}


#Preview {
    LoginView()
}
