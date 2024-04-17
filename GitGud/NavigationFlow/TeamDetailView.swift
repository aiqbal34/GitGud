//
//  TeamDetailView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 4/14/24.
//
import SwiftUI

struct TeamDetailView: View {
    var teamName: Team
    
    var body: some View {
        ZStack {
            GradientStyles.backgroundGradient.ignoresSafeArea()
            
            Spacer()
            VStack {
                List{
                    Section(header: Text("Emails:")){
                        ForEach(teamName.emails.indices, id: \.self) { index in
                            Text("\(teamName.emails[index])")
                                .foregroundColor(Color(hex: "#543C86"))
                                .font(.system(size: 14))
                                .lineSpacing(2)
                        }
                    }
                    Section(header: Text("People:")){
                        ForEach(teamName.people.indices, id: \.self) { index in
                            Text("\(teamName.people[index])")
                                .foregroundColor(Color(hex: "#543C86"))
                                .font(.system(size: 14))
                                .lineSpacing(2)
                        }
                    }
                    Section(header: Text("Project Description:")){
                        Text(teamName.project.description)
                            .foregroundColor(Color(hex: "#543C86"))
                            .font(.system(size: 16))
                            .lineSpacing(4)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    }
                }
                .listRowBackground(Color.white)
                .foregroundColor(Color(hex: "#543C86"))
            }
        }
    }
}
