//
//  MessagingView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 5/14/24.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase

struct Message: Identifiable {
    let id = UUID()
    let sender: String
    let content: String
}

struct MessagingView: View {
    @State private var messages: [Message] = []
    @State private var newMessage = ""
    @FocusState var isKeyBoard: Bool
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(messages) { message in
                        Text(message.sender)
                            .font(.headline)
                        + Text(": \(message.content)")
                    }
                }
            }
            HStack {
                TextField("New Message", text: $newMessage)
                    .frame(width: 250, height: 50)
                    .background(.gray)
                    .cornerRadius(3.0)
                    .focused($isKeyBoard)
              
                Button("Send") {
                    sendMessage()
                    newMessage = ""
                }
                .frame(width: 100, height: 50) // Adjust height as desired
                .foregroundColor(.black)
                .background(.blue)
                .cornerRadius(10)
            }
            .padding(.horizontal)
        }.onTapGesture {
            isKeyBoard = false
        }
    }
    
    func sendMessage() {
        guard !newMessage.isEmpty else { return }
        let message = Message(sender: "Me", content: newMessage)
        messages.append(message)
    }
}



#Preview {
    MessagingView()
}
