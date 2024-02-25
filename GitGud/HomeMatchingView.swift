//
//  HomeMatchingView.swift
//  GitGud
//
//  Created by Sajed Hussein on 2/24/24.
//

import SwiftUI

struct HomeMatchingView: View {
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    
                    HStack {
                        Circle()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                            .padding(.top, 60)
                        
                        Text("John Doe")
                            .font(.title)
                            .foregroundColor(Color.white)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 60)
    
                    }
                    
                    ScrollView{
                        Text("Inser information here")
                            .foregroundColor(Color.text)
                    }
                    .frame(width: 300,height: 450) // Set a fixed height for the ScrollView
                    .border(Color.gray, width: 1) // Optional border to visualize the ScrollView frame
                    .background(Color.secondaryBackground)
                    .padding()
                    
                    HStack{
                        Button("Match") {
                            // do magic
                        }
                        .foregroundColor(Color.text)
                        .frame(width: 130, height: 64)
                        .background(Color.secondaryBackground)
                        .padding(.horizontal)
                        
                        Button("Next") {
                            // do magic
                        }
                        .foregroundColor(Color.text)
                        .frame(width: 130, height: 64)
                        .background(Color.secondaryBackground)
                        .padding(.horizontal)
                        
                    }
                    
                    Spacer()
                }
            
                
            }
            .ignoresSafeArea(.all)
            .background(Color.background)
            
        }
       
    }
}


#Preview {
    HomeMatchingView()
        .modelContainer(for: Item.self, inMemory: true)
}
