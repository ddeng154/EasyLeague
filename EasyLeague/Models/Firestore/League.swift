//
//  League.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/21/22.
//

import Foundation

class League: Codable {
    
    let id: String
    let ownerUserID: String
    var name: String
    var memberUserIDs: [String]
    let teams: [Team]
    let schedule: [Matchups]
    var results: [Outcomes]
    var playerStats: [String : [String : Int]]
    var teamStats: [String : [Int]]
    let type: String
    let allowTies: Bool
    
    init(id: String, userID: String, name: String, numTeams: Int, numMatches: Int, stats: [String : Bool], type: String, allowTies: Bool) {
        self.id = id
        self.ownerUserID = userID
        self.name = name
        self.memberUserIDs = [userID]
        self.teams = (0..<numTeams).map(Team.init)
        self.teams.first?.memberUserIDs.append(userID)
        self.schedule = Self.createSchedule(numTeams: numTeams, numMatches: numMatches)
        self.results = []
        self.playerStats = Dictionary(uniqueKeysWithValues: stats.compactMap { (stat, forPlayer) in forPlayer ? (stat, [:]) : nil })
        self.teamStats = Dictionary(uniqueKeysWithValues: stats.keys.map { stat in (stat, Array(repeating: 0, count: numTeams)) })
        self.type = type
        self.allowTies = allowTies
    }
    
    static func createSchedule(numTeams: Int, numMatches: Int) -> [Matchups] {
        let total = Array(0..<numTeams) + (numTeams.isMultiple(of: 2) ? [] : [-1])
        var first = Array(total[0..<(total.count / 2)])
        var second = Array(total[(total.count / 2)...].reversed())
        var schedule: [Matchups] = []
        for _ in 1...numMatches {
            var matchups: [Matchup] = []
            for (a, b) in zip(first, second) {
                if a != -1 && b != -1 {
                    matchups.append(Matchup(teamA: a, teamB: b))
                }
            }
            schedule.append(Matchups(value: matchups))
            second.append(first.removeLast())
            first.insert(second.removeFirst(), at: 1)
        }
        return schedule
    }
    
}

extension League {
    
    func teamWith(userID: String) -> Team? {
        teams.first { t in t.memberUserIDs.contains(userID) }
    }
    
    func copy() throws -> League {
        let data = try JSONEncoder().encode(self)
        return try JSONDecoder().decode(Self.self, from: data)
    }
    
}
