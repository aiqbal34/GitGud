//
//  PhoneInputView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/26/24.
//

import SwiftUI

struct PhoneInputView: View {
    
    @State var phoneNumber = ""
    @FocusState var isKeyBoard: Bool
    
    @EnvironmentObject var userModel: UserModel
    
    @State var move_to_loading_view = false
    var body: some View {
        NavigationStack {
            ZStack {
                GradientStyles.backgroundGradient
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Text("Enter Phone Number")
                        .font(.system(size: 24))
                        .foregroundColor(Color(hex: "#543C86"))
                        .fontDesign(.monospaced)
                        .padding(.bottom)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text("🇺🇸 +1")
                        //.padding(.leading, 100)
                        TextField("Enter Phone Number", text: $phoneNumber)
                            .frame(width: 200)
                            .foregroundColor(Color(hex: "#543C86"))
                            .fontDesign(.monospaced)
                            .focused($isKeyBoard)
                            .keyboardType(.numberPad)
                    }
                    Rectangle()
                        .frame(width: 250, height: 2)
                        .foregroundColor(Color(hex: "#543C86"))
                        .padding(.bottom)
                    Spacer()
                    HStack {
                        Spacer()
                        Button("Next") {
                            userModel.phone = phoneNumber
                            move_to_loading_view = true
                        }
                        .padding(.trailing, 35)
                        .padding(.top, 25)
                        .foregroundColor(Color(hex: "#543C86"))
                        .fontWeight(.bold)
                        
                    }
                    
                }
                
            }.onTapGesture {
                isKeyBoard = false
            }
            .navigationDestination(isPresented: $move_to_loading_view) {
                LoadingView(currUserID: userModel.userID, getData: false)
                    .environmentObject(userModel)
            }
        }
    }
}

#Preview {
    PhoneInputView()
}
