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
    var numMatchesPlayed: Int
    var playerStats: [String : [String : Statistic]]
    var teamStats: [String : [Statistic]]
    
    init(id: String, userID: String, name: String, numTeams: Int, numMatches: Int, stats: [String : Bool]) {
        let range = (0..<numTeams)
        self.id = id
        self.ownerUserID = userID
        self.isStarted = false
        self.name = name
        self.memberUserIDs = [userID]
        self.teams = range.map(Team.init)
        self.teams.first?.memberUserIDs.append(userID)
        self.numMatches = numMatches
        self.numMatchesPlayed = 0
        self.playerStats = Dictionary(uniqueKeysWithValues: stats.compactMap { (stat, forPlayer) in forPlayer ? (stat, [:]) : nil })
        self.teamStats = Dictionary(uniqueKeysWithValues: stats.keys.map { stat in (stat, range.map { _ in Statistic() }) })
    }
    
    func teamWith(userID: String) -> Team? {
        teams.first { t in t.memberUserIDs.contains(userID) }
    }
    
}
