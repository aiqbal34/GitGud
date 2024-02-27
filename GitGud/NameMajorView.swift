//
//  NameMajorView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/26/24.
//

import SwiftUI

struct NameMajorView: View {
    @State var name = ""
    @State var Major = ""
    @State var email = ""
    @FocusState var isKeyBoard: Bool
    var dropDownItem: [String] = ["Computer Science", "ELECTIRCAL"]
    
    var body: some View {
        
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Create Profile")
                    .font(.system(size: 24))
                    .foregroundColor(.text)
                    .fontDesign(.monospaced)
                    .padding(.bottom)
                    .fontWeight(.bold)
                HStack {
                    TextField("Name", text: $name)
                        .frame(width: 200)
                        .foregroundColor(.text)
                        .fontDesign(.monospaced)
                        .focused($isKeyBoard)
                }
                Rectangle()
                    .frame(width: 200, height: 2)
                    .foregroundColor(.text)
                    .padding(.bottom)
                
                Picker("Select Major", selection: $Major) {
                    ForEach(dropDownItem, id: \.self) { item in
                        Text(item)
                            .foregroundColor(.blue) // Change the text color
                            .font(.headline) // Set the font style
                            .padding() // Add some padding around each text
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                
                
                HStack {
                    TextField("Email", text: $email)
                        .frame(width: 200)
                        .foregroundColor(.text)
                        .fontDesign(.monospaced)
                        .focused($isKeyBoard)
                }
                Rectangle()
                    .frame(width: 200, height: 2)
                    .foregroundColor(.text)
                    .padding(.bottom, 40)
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
            
        }
        
    }
}

#Preview {
    NameMajorView()
}
