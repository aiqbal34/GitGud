//
//  TechStackView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/26/24.
//

import SwiftUI

struct TechStackView: View {
    
    @State var experience = ""
    var experienceLevels = ["low", "medium", "high"]
    
    @State var techStack = ""
    var techStackList = ["MERN", "React", "Svelte"]
    
    @State var idk = "idk"
    var idklist = ["idk"]
    
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
                
                Text("Select Expereince")
                    .font(.system(size: 18))
                    .foregroundColor(.text)
                    .fontDesign(.monospaced)
                    .padding(.top)
                    .fontWeight(.bold)
                Picker("Select Major", selection: $experience) {
                    ForEach(experienceLevels, id: \.self) { item in
                        Text(item)
                            .foregroundColor(.blue) // Change the text color
                            .font(.headline) // Set the font style
                            .padding() // Add some padding around each text
                    }
                }
                .pickerStyle(SegmentedPickerStyle()) // Apply MenuPickerStyle
                .padding() // Add padding around the picker
                .background(Color.secondaryBackground) // Set background color
                .cornerRadius(10)
                .frame(height: 100)// Add corner radius
                
                
                Text("Select Tech Stack")
                    .font(.system(size: 18))
                    .foregroundColor(.text)
                    .fontDesign(.monospaced)
                    .padding(.bottom)
                    .fontWeight(.bold)
                Picker("Select Major", selection: $techStack) {
                    ForEach(techStackList, id: \.self) { item in
                        Text(item)
                            .foregroundColor(.blue)
                            .font(.headline)
                            .padding()
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding()
                .background(Color.secondaryBackground)
                .cornerRadius(10)
                .frame(height: 150)
                
                
                Picker("", selection: $idk) {
                    ForEach(idklist, id: \.self) { item in
                        Text(item)
                            .foregroundColor(.blue)
                            .font(.headline)
                            .padding()
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding()
                .background(Color.secondaryBackground)
                .cornerRadius(10)
                .frame(height: 100)
              
                
                Spacer()
                HStack {
                    Spacer()
                    Button("Next") {
                        //implement
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
    TechStackView()
}
