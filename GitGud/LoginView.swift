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
    
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            VStack {
                Text("Sign in")
                    .font(.system(size: 24))
                    .foregroundColor(.text)
                    .fontDesign(.monospaced)
                    .padding(.bottom)
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
            }

        }.onTapGesture {
            isKeyBoard = false
        }
    }
}

#Preview {
    LoginView()
}
