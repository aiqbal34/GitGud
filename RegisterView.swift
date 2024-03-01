//
//  RegisterView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/24/24.
//

import SwiftUI

struct RegisterView: View {
    
    @State var userName = ""
    @State var password = ""
    @State var reEnterpPssword = ""
    @FocusState var isKeyBoard: Bool
    
    
    var body: some View {
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
                
                TextField("Username", text: $userName)
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
                
                Rectangle()
                    .frame(width: 200, height: 2)
                    .foregroundColor(.text)
                    .padding(.bottom, 25)
                
                SecureField("ReEnter Password", text: $reEnterpPssword)
                    .frame(width: 200)
                    .foregroundColor(.text)
                    .focused($isKeyBoard)
                
                
                Rectangle()
                    .frame(width: 200, height: 2)
                    .foregroundColor(.text)
                    .padding(.bottom, 40)
                Spacer()
                HStack {
                    Spacer()
                    Button("Next") {
                        Task {
                            if password == reEnterpPssword {
                                await create_Account(email: userName, password: password)
                            }
                        }
                    }
                    .padding(.trailing, 35)
                    .padding(.top, 25)
                    .foregroundColor(.text)
                    .fontWeight(.bold)
                    
                }
                
            }
            
        }.onTapGesture {
            isKeyBoard = false
        }
    }
}

#Preview {
    RegisterView()
}
