//
//  Api.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/28/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase

struct UserData: Decodable {
    let name: String
    let phone: Int
    let id: String
}


func fetchData() async throws -> UserData {
    guard let url = URL(string: "http://127.0.0.1:5000") else {
        throw URLError(.badURL)
    }

    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        return try decoder.decode(UserData.self, from: data)
    } catch {
        throw error
    }
}

//this function allows the user to signin
func userSignIn(email: String, password: String) async throws -> String? {
  do {
    let result = try await Auth.auth().signIn(withEmail: email, password: password)
      print(result.user.uid)
      return result.user.uid
  } catch {
      
    print("Error signing in: \(error)")
    throw error
    
  }
}

//this function allows the user to create an account
func create_Account(email: String, password: String) async {
    do {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        print(result)
    }catch {
        print("Error creating Account: \(error)")
    }
    
}




class UserModel: ObservableObject {
    var name: String
    var phone: Int
    var userID: String
    var major: String
    var university: String
    var teams: Array<Member>
    var experience: [String]
    var requests: [Member]
    var techStack: [String]
    var profilePic: UIImage?
    var email: String
    // add requests   [Member]
    // add tech stack [Strings]
    // add profile pic
    
    

    init() {
        self.name = ""
        self.phone = 0
        self.userID = ""
        self.major = ""
        self.university = ""
        self.teams = []
        self.experience = []
        self.requests = []
        self.techStack = []
        self.profilePic = nil
        self.email = ""
    }
}

/*
 TextField("Username", text: $userName)
 TextField("Password", text: $password)
 TextField("Email", text: $email)
 TextField("University", text: $university)
 TextField("Major", text: $major)
 */
