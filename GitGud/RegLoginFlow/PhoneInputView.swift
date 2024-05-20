import SwiftUI
import Firebase

struct EmailVerificationView: View {
    @State private var errorMessage = ""
    @State private var successMessage = ""
    @State private var move_to_loading_view = false
    
    @State var email: String
    @State var password: String
    
    @EnvironmentObject var userModel: UserModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientStyles.backgroundGradient.ignoresSafeArea()
                VStack {
                    Text("A verification email has been sent to your email address. Please check your email to verify your account.")
                        .padding()
                    
                    Button("Resend Verification Email") {
                        Task {
                            await resendVerificationEmail()
                        }
                    }
                    .frame(width: 200, height: 50)
                    .background(Color.white)
                    .foregroundColor(Color(hex: "#543C86"))
                    .fontDesign(.monospaced)
                    .cornerRadius(10)
                    .fontWeight(.bold)
                    .padding()
                    
                    Button("Confirm Account") {
                        Task {
                            try await checkEmailVerificationStatus()
                        }
                    }
                    .frame(width: 200, height: 50)
                    .background(Color.white)
                    .foregroundColor(Color(hex: "#543C86"))
                    .fontDesign(.monospaced)
                    .cornerRadius(10)
                    .fontWeight(.bold)
                    .padding()
                    
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                    
                    Text(successMessage)
                        .foregroundColor(.green)
                        .padding()
                }
                .padding()
            }
        }
        .navigationDestination(isPresented: $move_to_loading_view) {
            LoadingView(currUserID: userModel.userID, getData: false)
                .environmentObject(userModel)
        }
    }
    
    func resendVerificationEmail() async {
        do {
            guard let user = Auth.auth().currentUser else {
                throw NSError(domain: "User not found", code: 404, userInfo: nil)
            }
            try await user.sendEmailVerification()
            successMessage = "Verification email resent. Please check your email."
        } catch {
            errorMessage = "Error sending verification email: \(error.localizedDescription)"
        }
    }
    
    func checkEmailVerificationStatus() async throws{
        if let currentUser = Auth.auth().currentUser {
            do {
                try await currentUser.reload()
                if currentUser.isEmailVerified {
                    // User is verified, proceed to create an account in your backend
                    move_to_loading_view = true
                } else {
                    errorMessage = "Email not verified yet. Please check your email."
                }
            } catch {
                errorMessage = "Error checking verification status: \(error.localizedDescription)"
            }
        } else {
            errorMessage = "No current user found."
        }
    }
}


