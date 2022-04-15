//
//  Matchup.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/14/22.
//

class Matchup: Codable {
    
    let teamA: Int
    let teamB: Int
    
    init(teamA: Int, teamB: Int) {
        self.teamA = teamA
        self.teamB = teamB
    }
    
}

class Matchups: Codable {
    
    let value: [Matchup]
    
    init(value: [Matchup]) {
        self.value = value
    }
    
}
