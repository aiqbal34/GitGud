import SwiftUI

struct TeamDetailView: View {
    @EnvironmentObject var userModel: UserModel // Assuming a model that tracks user data
    var teamName: Team
    
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            GradientStyles.backgroundGradient.ignoresSafeArea()
            
            NavigationStack {
                VStack {
                    List {
                        Section(header: Text("Team Members:")) {
                            ForEach(teamName.people., id: \.self) { key in
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(teamName.people[key] ?? "Unknown")
                                            .foregroundColor(Color(hex: "#543C86"))
                                            .font(.system(size: 14))
                                            .lineSpacing(2)
                                }
                                .swipeActions {
                                        Button(role: .destructive) {
                                            Task {
                                                await removeMember(index: index)
                                            }
                                        } label: {
                                            Label("Remove", systemImage: "minus.circle")
                                        }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        Section(header: Text("Project Description:")) {
                            ScrollView {
                                Text(teamName.project.description)
                                    .foregroundColor(Color(hex: "#543C86"))
                                    .font(.system(size: 16))
                                    .lineSpacing(4)
                                    .multilineTextAlignment(.leading)
                                    .padding(.vertical, 4)
                            }
                        }
                    }
                }
            }
            .alert(alertMessage, isPresented: $showAlert) {}
            .scrollContentBackground(.hidden)
            .foregroundColor(Color(hex: "#543C86"))
            .navigationTitle(teamName.project.projectName)
        }
    }
    
    private func removeMember(index: Int) async {
        do {
            let result = try await removeTeamMember(currUser: userModel.userID,
                                                    teamID: teamName.teamID,
                                                    userToRemove: teamName.people[index])
            DispatchQueue.main.async {
                alertMessage = result
                showAlert = true
            }
        } catch {
            DispatchQueue.main.async {
                alertMessage = "Failed to remove member: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
}
