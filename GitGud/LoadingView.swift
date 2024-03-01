//
//  LoadingView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/28/24.
//

import SwiftUI

struct LoadingView: View {
    @EnvironmentObject var userModel: UserModel
    var result: String?
    
    var getData: Bool
    
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
            ProgressView("Loading…", value: 0.99)
                .progressViewStyle(CircularProgressViewStyle(tint: .text))
                .scaleEffect(1.5)
                .foregroundColor(.text)
                .monospaced()
        }.onAppear {
            Task {
                if (getData) {
                    // implement getData
                } else {
                    try await postData(userData: userModel, urlString: "createBasicAccount")
                }
            }
        }
    }
}

//#Preview {
//    LoadingView()
//}
