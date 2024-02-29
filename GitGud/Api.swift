//
//  Api.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/28/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Firebase

struct UserData: Decodable{
    let name: String
    let phone: Int
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

func create_Account(email: String, password: String) {
    Auth.auth().createUser(withEmail: email, password: password) { Result, error in
        if error != nil {
            print(error?.localizedDescription)
        }
        print(Result)
    }
}
