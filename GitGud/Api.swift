//
//  Api.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/28/24.
//

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

func postData(userData: UserModel, urlString: String) async throws {
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




class UserModel: ObservableObject, Encodable {
    var name: String
    var phone: String
    var userID: String
    var major: String
    var university: String
    var teams: Array<Member>
    var experience: String
    var requests: [Member]
    var techStack: [String]
    var email: String
    // add requests   [Member]
    // add tech stack [Strings]
    // add profile pic
    
    

    init() {
        self.name = ""
        self.phone = ""
        self.userID = ""
        self.major = ""
        self.university = ""
        self.teams = []
        self.experience = ""
        self.requests = []
        self.techStack = []
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
