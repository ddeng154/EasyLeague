//
//  League.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/21/22.
//

class League: Codable {
    
    let id: String
    let ownerUserID: String
    var isStarted: Bool
    var name: String
    var memberUserIDs: [String]
    let teams: [Team]
    var numMatches: Int
    var statistics: [String : Bool]
    
    init(id: String, userID: String, name: String, numTeams: Int, numMatches: Int, statistics: [String : Bool]) {
        self.id = id
        self.ownerUserID = userID
        self.isStarted = false
        self.name = name
        self.memberUserIDs = [userID]
        self.teams = (0..<numTeams).map(Team.init)
        self.teams.first?.memberUserIDs.append(userID)
        self.numMatches = numMatches
        self.statistics = statistics
    }
    
    func teamWith(userID: String) -> Team? {
        teams.first { t in t.memberUserIDs.contains(userID) }
    }
    
}
