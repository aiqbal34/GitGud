//
//  HackthonsView.swift
//  GitGud
//
//  Created by Sajed Hussein on 5/7/24.
//

import Foundation
import SwiftUI

struct HackathonCardView: View {
    var hackathon: Hackathon
    
    var body: some View {
        VStack {
            HStack{
                Image("intel")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipped()
                    .cornerRadius(12)
                
                Text(hackathon.name)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .foregroundColor(.black)
            }
            VStack{
                HStack {
                    Text(hackathon.organizer)
                        .font(.subheadline)
                    Spacer()
                    Text("\(hackathon.participants) participants")
                        .font(.subheadline)
                }
                .foregroundColor(.secondary)
                HStack{
                    Text(hackathon.duration)
                        .font(.caption)
                    Spacer()
                    Text(hackathon.prize)
                        .font(.caption)
                }
                HStack {
                    ForEach(hackathon.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(5)
                            .background(Color.blue)
                            .cornerRadius(5)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding()
        .background(Color(.white))
        .cornerRadius(16)
        .shadow(radius: 5)
    }
}
        
struct ContentView: View {
    var hackathons: [Hackathon] = [
        Hackathon(name: "Microsoft Developers AI Learning Hackathon", organizer: "Microsoft", duration: "Apr 17 - Jun 18, 2024", prize: "$10,000 in prizes", participants: 3840, tags: ["Databases", "Machine Learning/AI", "Beginner Friendly"], isFeatured: true),
        // Additional hackathons can be added here
    ]

    var body: some View {
        ZStack {
            GradientStyles.backgroundGradient.ignoresSafeArea()
            List(hackathons) { hackathon in
                HackathonCardView(hackathon: hackathon)
                    .listRowBackground(Color.clear) 
                
            }
            .background(Color.clear)  // Set the List background to clear
            .listStyle(PlainListStyle())  // Optionally use PlainListStyle for
        }
    }
}

#Preview{
    ContentView()
}

