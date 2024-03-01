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

struct UserData: Decodable{
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
func userSignIn(email: String, password: String) async throws -> User? {
  do {
    let result = try await Auth.auth().signIn(withEmail: email, password: password)
      print(result.user.uid)
    return result.user
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
//class UserModel: ObservableObject {
//    let name: String
//    let phone: Int
//    let userID: String
//    let major: String
//    let 
//}
