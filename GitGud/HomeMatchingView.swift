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
                        Spacer()
                        
                        Circle()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                            .padding(.top, 60)
                        
                        Spacer()
                            
                        
                        Text("John Doe")
                            .font(.system(size: 45))
                            .foregroundColor(Color.white)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 60)
                        
                        Spacer()
    
                    }
                    
                    ScrollView{
                        Text("Inser information here")
                            .foregroundColor(Color.text)
                    }
                    .frame(width: 300,height: 450)
                    .background(Color.secondaryBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 10)) // Clip the view with rounded corners

                    
                    HStack{
                        Button("Match") {
                            // do magic
                        }
                        .foregroundColor(Color.text)
                        .frame(width: 130, height: 64)
                        .background(Color.secondaryBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 10)) // Clip the view with rounded corners
                        .padding(.horizontal)
                        
                        Button("Next") {
                            // do magic
                        }
                        .foregroundColor(Color.text)
                        .frame(width: 130, height: 64)
                        .background(Color.secondaryBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 10)) // Clip the view with rounded corners
                        .padding()
                        
                    }
                    
                    //NavigationBar()
                    
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
}
