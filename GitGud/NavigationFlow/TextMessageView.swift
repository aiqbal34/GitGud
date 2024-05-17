//
//  TextMessageView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 4/23/24.
//

import SwiftUI
import Firebase
import Firebase
import FirebaseDatabase
// Define a simple message model
struct Message: Identifiable {
    var id = UUID()
    var content: String
}

// Define the ContentView
struct TextMessageView: View {
    @State private var messages: [Message] = []
    @State private var currentMessage: String = ""

    var body: some View {
        NavigationView {
            VStack {
                // Messages list
                List(messages) { message in
                    Text(message.content)
                        .padding()
                }
                // Message input area
                HStack {
                    TextField("Type a message...", text: $currentMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button(action: sendMessage) {
                        Text("Send")
                            .bold()
                    }
                    .padding()
                    .disabled(currentMessage.isEmpty)
                }
            }
            .onAppear {
                setupFirebaseListeners()
            }
            .navigationBarTitle("Messages")
        }
    }

    // Function to send a message
    func sendMessage() {
        let newMessage = Message(content: currentMessage)
        messages.append(newMessage)
        currentMessage = ""
    }
}


