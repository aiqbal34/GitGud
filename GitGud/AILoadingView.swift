//
//  AILoadingView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 3/9/24.
//

import SwiftUI

struct AILoadingView: View {
    
    var projectBuild: ProjectBuild
    
    @State var pickMembersView = false
    @EnvironmentObject var userModel: UserModel
  
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background).ignoresSafeArea()
                ProgressView("Loading…", value: 0.99)
                    .progressViewStyle(CircularProgressViewStyle(tint: .text))
                    .scaleEffect(1.5)
                    .foregroundColor(.text)
                    .monospaced()
            }
            .onAppear{
                Task {
                    do {
                        try await sendReqToAiModel(description: projectBuild, urlString: "generateTeam")
                        pickMembersView = true
                    } catch {
                        print(error)
                    }
                }
            }
            .navigationDestination(isPresented: $pickMembersView){
                FindMembersView(viewModel:
                                    TeamMembersViewModel(numberOfMembers: projectBuild.teamSize))
                .environmentObject(userModel)
              
            }
            .navigationBarBackButtonHidden()
        }
    }
}

