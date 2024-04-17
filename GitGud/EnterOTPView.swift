//
//  EnterOTPView.swift
//  GitGud
//
//  Created by Isa Bukhari on 2/27/24.
//


import SwiftUI

struct EnterOTPView: View {
    @State var pin = ""
    @State var box1 = ""
    @State var box2 = ""
    @State var box3 = ""
    @State var box4 = ""
    @State var box5 = ""
    @State var box6 = ""
    @State var validOTP = false
    @State var message = ""
    @Binding var phoneNum: String
    enum boxNum {
        case boxOne
        case boxTwo
        case boxThree
        case boxFour
        case boxFive
        case boxSix
    }
    @FocusState var boxFocus : Bool
    
    var body: some View {
        
        ZStack {
            Color(hex: "#7E7FE3")
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack{
                Text("Enter Your OTP")
                
                    .padding()
                    .fontDesign(.monospaced)
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(hex: "#543C86"))
                    
                Text("Sent to \(phoneNum)")
                    .foregroundColor(Color(hex: "#543C86"))
                ZStack{
                    //An HStack of 6 identical text view boxes
                    HStack(spacing: 10) {
                        Group{
                            Text(box1)
                            Text(box2)
                            Text(box3)
                            Text(box4)
                            Text(box5)
                            Text(box6)
                            //an on change function in the sixth box to do the api call to verify the OTP
                                .onChange(of: box6){
                                    Task {
                                        
                                    }
                                }
                        }
                        .frame(width: 40, height: 40)
                        .background(Color.white)
                        .foregroundColor(Color(hex: "#543C86"))
                        .cornerRadius(5)
                        .multilineTextAlignment(.center)
                    }
                    //The hidden text field where the user inputs the OTP
                    TextField("", text: $pin)
                        .padding()
                        .frame(width: 0, height: 0)
                        .keyboardType(.numberPad)
                        .padding()
                        .focused($boxFocus)
                        .onChange(of: pin){
                            updateCharacters()
                            //caps the input length at 6
                            if(pin.count > 6){
                                pin = String(pin.prefix(6))
                            }
                        }
                        .onAppear{
                            boxFocus = true
                        }
                }
                //A button to resend the OTP which does an API call to send the OTP to the phone number
                Button("Resend OTP"){
                    
                }
                .padding()
                .background(Color.white)
                .foregroundColor(Color(hex: "#543C86"))
                .cornerRadius(25)
                
                
                Text(message)
                
            }
        }
        //navigates to the Home View if the OTP is valid
    }
    
    //A function which updates the individual characters in the boxes when passed in the OTP
    func updateCharacters() {
            let charactersArray = Array(pin)
            box1 = charactersArray.count > 0 ? String(charactersArray[0]) : ""
            box2 = charactersArray.count > 1 ? String(charactersArray[1]) : ""
            box3 = charactersArray.count > 2 ? String(charactersArray[2]) : ""
            box4 = charactersArray.count > 3 ? String(charactersArray[3]) : ""
            box5 = charactersArray.count > 4 ? String(charactersArray[4]) : ""
            box6 = charactersArray.count > 5 ? String(charactersArray[5]) : ""
        }
}




#Preview {
    EnterOTPView(phoneNum: .constant(""))
}

