//
//  Api.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/28/24.
// 

import SwiftUI
// global background style
extension Color {
  init(hex: String) {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
    var rgb: UInt64 = 0
    var r, g, b: CGFloat

    Scanner(string: hexSanitized).scanHexInt64(&rgb)

    let length = hexSanitized.count
   
      r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
      g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
      b = CGFloat(rgb & 0x0000FF) / 255.0
    

    self.init(red: r, green: g, blue: b)
  }
}


struct GradientStyles {
    static var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "#7E7FE3"), Color.white]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}



import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase



var url = "http://127.0.0.1:5000/"
// "https://gitgud-415705.uc.r.appspot.com/"
//"https://backendgg-9e8e232e3312.herokuapp.com/"



/*
 This function fetches Users for Home page
 */

func fetchUsersForHomePage(currUser: String) async throws -> [UserModel] {
    guard let url = URL(string: "\(url)?currUser=\(currUser)") else {
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

/*
 This function fetches the current users informatoin
 */

func fetchCurrentUsersInformation(urlString: String, currUser: String) async throws -> UserModel {
    guard let url = URL(string: "\(url)\(urlString)?currUser=\(currUser)") else {
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

/*
 This function fetches the current users teams
 */
func fetchCurrentUserTeam(currUser: String) async throws -> UserTeamData {
    guard let url = URL(string: "\(url)getCurrentUserTeams?currUser=\(currUser)") else {
        throw URLError(.badURL)
    }
    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        do {
            try print(decoder.decode(UserTeamData.self, from: data))
        } catch {
            print("Failed")
        }
        try print(decoder.decode(UserTeamData.self, from: data))
        return try decoder.decode(UserTeamData.self, from: data) // Decode into an array of UserModel
    } catch {
        throw error
    }
}


func updateUser(currUser: String, updatedUser: UserModel) async throws {
    // Construct URL with query parameters
    guard let url = URL(string: "\(url)updateUser?currUser=\(currUser)") else {
        throw URLError(.badURL)
    }
    
    // Create POST request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        // Encode teamDescription to JSON data
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(updatedUser)
        
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

/*
 This function takes in two paramters, skills and the experiencelevel
 returns a list of users closest to those paramters
 */
func fetchFilteredList(skills: [String], experienceLevel: String) async throws -> [UserModel] {
    var components = URLComponents(string: "\(url)findMember")
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

/*
 This function sends a match
 */

func sendMatch(currUser: String, sentUser: String) async throws {
    guard let url = URL(string: "\(url)match?currUser=\(currUser)&sentUser=\(sentUser)") else {
        throw URLError(.badURL)
    }
    
    let (_, response) = try await URLSession.shared.data(from: url)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    
}
/*
 This function sends a Team Match to another User
 */

func sendTeamMatch(currUser: String, sentUser: String, teamID: String) async throws {
    // Construct URL with query parameters
    guard let url = URL(string: "\(url)sendTeamMatch?currUser=\(currUser)&sentUser=\(sentUser)") else {
        throw URLError(.badURL)
    }
    
    // Create POST request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        // Encode teamDescription to JSON data
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(teamID)
        
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
/*
 This function ccreates a team and puts it in the database
 */
func createTeam(currUser: String, teamDescription: Team) async throws -> createTeamResponse {
    // Construct URL with query parameters
    guard let url = URL(string: "\(url)createTeam?currUser=\(currUser)") else {
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
        
        let teamID = try JSONDecoder().decode(createTeamResponse.self, from: data)
        
        // Check response status code
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return teamID
        
    } catch {
        // Log or handle the error in a meaningful way
        print("Error: \(error)")
        throw error
    }
}
/*
 This rejectTeam is a function that rejects the teamRequest
 */
func rejectTeam(currUser: String, teamID: String) async throws {
    print("In reject Team")
    guard let url = URL(string: "\(url)rejectTeamRequest?currUser=\(currUser)") else {
        throw URLError(.badURL)
    }
    
    // Create POST request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        // Encode teamDescription to JSON data
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(teamID)
        
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

func removeTeamMember(currUser: String, teamID: String, userToRemove: String) async throws -> String {
    print("Curr user id: ", currUser)
    print("this is the team id: ", teamID)
    print("id to remove: ", userToRemove)
    // Construct the URL with required query parameters
    guard let url = URL(string: "\(url)/removeTeamMember?currUser=\(currUser)&currTeam=\(teamID)&UserToRemove=\(userToRemove)") else {
        throw URLError(.badURL)
    }
    
    // Set up the URLRequest
    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    // Perform the HTTP request
    let (data, response) = try await URLSession.shared.data(for: request)

    // Check the response status code
    guard let httpResponse = response as? HTTPURLResponse else {
        throw URLError(.cannotParseResponse)
    }

    // Check for HTTP error responses
    switch httpResponse.statusCode {
    case 200:
        // Handle a successful response
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let message = json["message"] as? String {
            return message
        } else {
            throw URLError(.cannotDecodeContentData)
        }
    case 403:
        throw NSError(domain: "API", code: 403, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])
    case 404:
        throw NSError(domain: "API", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not found"])
    default:
        // Handle other unexpected statuses
        throw NSError(domain: "API", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected response status code: \(httpResponse.statusCode)"])
    }
}


/*
 This acceptTeam function accepts a team request
 */
func acceptTeam(currUser: String, teamID: String) async throws {
    print("in accept team")
    guard let url = URL(string: "\(url)acceptTeamRequest?currUser=\(currUser)") else {
        throw URLError(.badURL)
    }
    
    // Create POST request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        // Encode teamDescription to JSON data
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(teamID)
        
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

/*
 This function rejects the rejectsUser for a request
 */
func rejectUser(currUser: String, rejectedUser: String) async throws {
    guard let url = URL(string: "\(url)rejectRequest?currUser=\(currUser)&rejectedUser=\(rejectedUser)") else {
        throw URLError(.badURL)
    }
    
    let (_, response) = try await URLSession.shared.data(from: url)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
}
/*
 This function accepts a user for when another user sends a Request
 */
func accpetUser(currUser: String, acceptUser: String) async throws {
    guard let url = URL(string: "\(url)acceptRequestAccepter?currUser=\(currUser)&acceptUser=\(acceptUser)") else {
        throw URLError(.badURL)
    }
    
    let (_, response) = try await URLSession.shared.data(from: url)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
}




    /*
     This function saves a new account
     */

func saveNewAccount(userData: UserModel, urlString: String) async throws {
    guard let url = URL(string: "\(url)\(urlString)") else {
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
    guard let url = URL(string: "\(url)\(urlString)") else {
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
