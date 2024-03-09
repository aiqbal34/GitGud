//
//  Api.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/28/24.
//
var allPeople: [UserModel] = []

let allSkills: [String] = [
    "HTML", "CSS", "JavaScript", "React", "Angular", "Vue.js",
    "Python", "Java", "C++", "PHP", "Ruby", "Go", "Node.js",
    "Assembly Language", "Swift", "Kotlin", "C#", "Perl",
    "R", "Scala", "TypeScript", "Dart", "Haskell",
    "Bootstrap", "jQuery", "Express.js", "Django", "Spring",
    "Laravel", "TensorFlow", "PyTorch", "Keras",
    "Git", "Agile", "Waterfall", "Unit testing",
    "Integration testing", "APIs", "Web Services", "SQL",
    "NoSQL", "MySQL", "PostgreSQL", "MongoDB", "Oracle",
    "SQLite", "Cassandra", "CouchDB",
    "Docker", "Kubernetes", "Jenkins", "Ansible",
    "Heroku", "DigitalOcean", "Linode",
    "Software Design Patterns", "Formal Languages & Automata Theory",
    "Compiler Design", "Operating Systems Design", "Computer Architecture",
    "Distributed Systems", "Computer Graphics", "Human-Computer Interaction (HCI)",
    "Natural Language Processing (NLP)", "Computer Vision", "Robotics",
    "Software Engineering Principles",
    "User Research", "Usability Testing", "Information Architecture",
    "User Interface (UI) Design", "User Experience (UX) Writing", "Wireframing",
    "Prototyping", "Interaction Design", "Visual Design", "Accessibility",
    "UI/UX Design Tools (e.g., Figma, Adobe XD)", "User Empathy", "Usability Heuristics",
    "User Persona Development", "Card Sorting", "A/B Testing", "User Flows",
    "Design Thinking", "Iterative Design", "User Interface (UI) Patterns",
    "Microinteractions", "Visual Communication", "Color Theory", "Typography"
]

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

func sendMatch(currUser: String, sentUser: String) async throws {
    guard let url = URL(string: "http://127.0.0.1:5000/match?currUser=\(currUser)&sentUser=\(sentUser)") else {
        throw URLError(.badURL)
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
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
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
    } catch {
        throw error
    }
}

//AI Model Part

//Struct for sending the user input to the ai model
struct ProjectBuild: Codable {
    var projectName: String
    var response: String
    var teamSize: Int
    var projectType: String
}

struct AiResponse: Codable {
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




class UserModel: ObservableObject, Codable, Equatable, Hashable {
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(userID)
    }
    
    var name: String
    var phone: String
    var userID: String
    var major: String
    var university: String
    var teams: [UserModel]
    var experience: String
    var connections: [UserModel]
    var teamConnections: [UserModel]
    var requests: [UserModel]
    var teamRequests: [UserModel]
    var techStack: [String]
    var email: String

    init() {
        self.name = ""
        self.phone = ""
        self.userID = ""
        self.major = ""
        self.university = ""
        self.teams = []
        self.experience = ""
        self.connections = []
        self.teamConnections = []
        self.requests = []
        self.teamRequests = []
        self.techStack = []
        self.email = ""
    }

    func hardCopy(user: UserModel) {
        self.name = user.name
        self.phone = user.phone
        self.userID = user.userID
        self.major = user.major
        self.university = user.university
        self.teams = user.teams
        self.experience = user.experience
        self.connections = user.connections
        self.teamConnections = user.teamConnections
        self.requests = user.requests
        self.teamRequests = user.teamRequests
        self.techStack = user.techStack
        self.email = user.email
    }

    func printModel() {
        print(self.name)
        print(self.email)
    }
}

/*
 TextField("Username", text: $userName)
 TextField("Password", text: $password)
 TextField("Email", text: $email)
 TextField("University", text: $university)
 TextField("Major", text: $major)
 */
