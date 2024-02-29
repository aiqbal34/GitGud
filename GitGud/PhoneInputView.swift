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
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Enter Phone Number")
                    .font(.system(size: 24))
                    .foregroundColor(.text)
                    .fontDesign(.monospaced)
                    .padding(.bottom)
                    .fontWeight(.bold)

                HStack {
                    TextField("Enter Phone Number", text: $phoneNumber)
                        .frame(width: 200)
                        .foregroundColor(.text)
                        .fontDesign(.monospaced)
                        .focused($isKeyBoard)
                        .keyboardType(.numberPad)
                }
                Rectangle()
                    .frame(width: 200, height: 2)
                    .foregroundColor(.text)
                    .padding(.bottom)
                Spacer()
                HStack {
                    Spacer()
                    Button("Next") {
                        
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
    PhoneInputView()
}
