//
//  LoadingView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/28/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
            ProgressView("Loading…", value: 0.99)
                .progressViewStyle(CircularProgressViewStyle(tint: .text))
                .scaleEffect(1.5)
                .foregroundColor(.text)
                .monospaced()
        }
    }
}

#Preview {
    LoadingView()
}
