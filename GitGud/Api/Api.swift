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


//initial fecthing of data

func fetchUsersForHomePage(currUser: String) async throws -> [UserModel] {
    guard let url = URL(string: "http://127.0.0.1:5000?currUser=\(currUser)") else {
        throw URLError(.badURL)
    }
    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        do {
            try print(decoder.decode([UserModel].self, from: data))
        } catch {
            print("Failed")
        }
        return try decoder.decode([UserModel].self, from: data) // Decode into an array of UserModel
    } catch {
        throw error
    }
}



func fetchCurrentUsersInformation(urlString: String, currUser: String) async throws -> UserModel {
    guard let url = URL(string: "http://127.0.0.1:5000/\(urlString)?currUser=\(currUser)") else {
        throw URLError(.badURL)
    }
    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        do {
            try print(decoder.decode(UserModel.self, from: data))
        } catch {
            print("Failed")
        }
        try print(decoder.decode(UserModel.self, from: data))
        return try decoder.decode(UserModel.self, from: data) // Decode into an array of UserModel
    } catch {
        throw error
    }
}

func fetchFilteredList(skills: [String], experienceLevel: String) async throws -> [UserModel] {
    var components = URLComponents(string: "http://127.0.0.1:5000/findMember")
    var queryItems = skills.map { URLQueryItem(name: "skills", value: $0) }
    queryItems.append(URLQueryItem(name: "experienceLevel", value: experienceLevel))
    
    components?.queryItems = queryItems
    
    guard let url = components?.url else {
        throw URLError(.badURL)
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    
    // Decode an array of UserModel from the response data
    let userModels = try JSONDecoder().decode([UserModel].self, from: data)
    
    for element in userModels {
        element.printModel()
    }
    return userModels
}



func sendMatch(currUser: String, sentUser: String) async throws {
    guard let url = URL(string: "http://127.0.0.1:5000/match?currUser=\(currUser)&sentUser=\(sentUser)") else {
        throw URLError(.badURL)
    }
    
    let (_, response) = try await URLSession.shared.data(from: url)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    
}

func sendTeamMatch(currUser: String, sentUser: String, teamDescription: Team) async throws {
    // Construct URL with query parameters
    guard let url = URL(string: "http://127.0.0.1:5000/sendTeamMatch?currUser=\(currUser)&sentUser=\(sentUser)") else {
        throw URLError(.badURL)
    }
    
    // Create POST request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        // Encode teamDescription to JSON data
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(teamDescription)
        
        // Set JSON data as HTTP body
        request.httpBody = jsonData
        
        // Send POST request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check response status code
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
    } catch {
        // Log or handle the error in a meaningful way
        print("Error: \(error)")
        throw error
    }
}

func createTeam(currUser: String, teamDescription: Team) async throws {
    // Construct URL with query parameters
    guard let url = URL(string: "http://127.0.0.1:5000/createTeam?currUser=\(currUser)") else {
        throw URLError(.badURL)
    }
    
    // Create POST request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        // Encode teamDescription to JSON data
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(teamDescription)
        
        // Set JSON data as HTTP body
        request.httpBody = jsonData
        
        // Send POST request
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // Check response status code
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
    } catch {
        // Log or handle the error in a meaningful way
        print("Error: \(error)")
        throw error
    }
}

func rejectTeam(currUser: String, teamDescription: Team) async throws {
    guard let url = URL(string: "http://127.0.0.1:5000/rejectTeamRequest?currUser=\(currUser)") else {
        throw URLError(.badURL)
    }
    
    // Create POST request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        // Encode teamDescription to JSON data
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(teamDescription)
        
        // Set JSON data as HTTP body
        request.httpBody = jsonData
        
        // Send POST request
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // Check response status code
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
    } catch {
        // Log or handle the error in a meaningful way
        print("Error: \(error)")
        throw error
    }
}

func acceptTeam(currUser: String, teamDescription: Team) async throws {
    guard let url = URL(string: "http://127.0.0.1:5000/acceptTeamRequest?currUser=\(currUser)") else {
        throw URLError(.badURL)
    }
    
    // Create POST request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        // Encode teamDescription to JSON data
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(teamDescription)
        
        // Set JSON data as HTTP body
        request.httpBody = jsonData
        
        // Send POST request
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // Check response status code
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
    } catch {
        // Log or handle the error in a meaningful way
        print("Error: \(error)")
        throw error
    }
}


func rejectUser(currUser: String, rejectedUser: String) async throws {
    guard let url = URL(string: "http://127.0.0.1:5000/rejectRequest?currUser=\(currUser)&rejectedUser=\(rejectedUser)") else {
        throw URLError(.badURL)
    }
    
    let (_, response) = try await URLSession.shared.data(from: url)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
}
func accpetUser(currUser: String, acceptUser: String) async throws {
    guard let url = URL(string: "http://127.0.0.1:5000/acceptRequestAccepter?currUser=\(currUser)&acceptUser=\(acceptUser)") else {
        throw URLError(.badURL)
    }
    
    let (_, response) = try await URLSession.shared.data(from: url)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
}






func saveNewAccount(userData: UserModel, urlString: String) async throws {
    guard let url = URL(string: "http://127.0.0.1:5000/\(urlString)") else {
        throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let encoder = JSONEncoder()
    do {
        request.httpBody = try encoder.encode(userData)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
    } catch {
        throw error
    }
}

//AI Model Part

//Struct for sending the user input to the ai model
struct ProjectBuild: Codable, Hashable {
    var projectName: String
    var description: String
    var teamSize: Int
    var projectType: String
}

struct AiResponse: Codable, Hashable {
    var number: String
    var skills: [String]
    var experienceLevel: String
}

//check why it is not decodable
func sendReqToAiModel(description: ProjectBuild, urlString: String) async throws -> [AiResponse] {
    guard let url = URL(string: "http://127.0.0.1:5000/\(urlString)") else {
        throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let encoder = JSONEncoder()
    do {
        request.httpBody = try encoder.encode(description)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let decodedResponse = try decoder.decode([AiResponse].self, from: data)
        print(decodedResponse)
        return decodedResponse
        
    } catch {
        // Log or handle the error in a meaningful way
        print("Error: \(error)")
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
//set this result for loadiing view
//this function allows the user to create an account
func create_Account(email: String, password: String) async throws -> String? {
    do {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        print(result.user.uid)
        return result.user.uid
    }catch {
        print("Error creating Account: \(error)")
        return nil
    }
}






/*
 TextField("Username", text: $userName)
 TextField("Password", text: $password)
 TextField("Email", text: $email)
 TextField("University", text: $university)
 TextField("Major", text: $major)
 */