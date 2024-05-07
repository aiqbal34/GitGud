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
                            ForEach(Array(teamName.people.sorted(by: { $0.key < $1.key })), id: \.key) { name, id in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(name)
                                        .foregroundColor(Color(hex: "#543C86"))
                                        .font(.system(size: 14))
                                        .lineSpacing(2)
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        Task {
                                            await removeMember(memberKey: id)  // Updated to use key
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
    
    private func removeMember(memberKey: String) async {
        print("this is the member key: ", memberKey)
        do {
            let result = try await removeTeamMember(currUser: userModel.userID,
                                                    teamID: teamName.teamID,
                                                    userToRemove: memberKey)
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
