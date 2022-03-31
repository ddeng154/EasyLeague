//
//  League.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/21/22.
//

class League: Codable {
    
    let id: String
    let ownerUserID: String
    var name: String
    var memberUserIDs: [String]
    let teams: [Team]
    var numMatches: Int
    
    init(id: String, userID: String, name: String, numTeams: Int, numMatches: Int) {
        self.id = id
        self.ownerUserID = userID
        self.name = name
        self.memberUserIDs = [userID]
        self.teams = (0..<numTeams).map(Team.init)
        self.teams.first?.memberUserIDs.append(userID)
        self.numMatches = numMatches
    }
    
}
