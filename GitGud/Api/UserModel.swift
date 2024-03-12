//
//  UserModel.swift
//  GitGud
//
//  Created by Aariz Iqbal on 3/11/24.
//

import Foundation


struct Team: Codable, Hashable {
    var people: [String]
    var ids: [String]
    var emails: [String]
    var project: ProjectBuild
    
    static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.people == rhs.people
    }
}

class UserModel: ObservableObject, Codable, Equatable, Hashable {
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.userID == rhs.userID
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
    @Published var requests: [UserModel]
    @Published var teamConnections: [Team]
    @Published var teamRequests: [Team]
    @Published var techStack: [String]
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
    
    
    enum CodingKeys: String, CodingKey {
        case name, phone, userID, major, university, teams, experience, connections, requests, teamConnections, teamRequests, techStack, email
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        phone = try container.decode(String.self, forKey: .phone)
        userID = try container.decode(String.self, forKey: .userID)
        major = try container.decode(String.self, forKey: .major)
        university = try container.decode(String.self, forKey: .university)
        teams = try container.decode([UserModel].self, forKey: .teams)
        experience = try container.decode(String.self, forKey: .experience)
        connections = try container.decode([UserModel].self, forKey: .connections)
        requests = try container.decode([UserModel].self, forKey: .requests)
        teamConnections = try container.decode([Team].self, forKey: .teamConnections)
        teamRequests = try container.decode([Team].self, forKey: .teamRequests)
        techStack = try container.decode([String].self, forKey: .techStack)
        email = try container.decode(String.self, forKey: .email)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(phone, forKey: .phone)
        try container.encode(userID, forKey: .userID)
        try container.encode(major, forKey: .major)
        try container.encode(university, forKey: .university)
        try container.encode(teams, forKey: .teams)
        try container.encode(experience, forKey: .experience)
        try container.encode(connections, forKey: .connections)
        try container.encode(requests, forKey: .requests)
        try container.encode(teamConnections, forKey: .teamConnections)
        try container.encode(teamRequests, forKey: .teamRequests)
        try container.encode(techStack, forKey: .techStack)
        try container.encode(email, forKey: .email)
    }
    func printModel() {
         print(self.name)
         print(self.email)
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
}
