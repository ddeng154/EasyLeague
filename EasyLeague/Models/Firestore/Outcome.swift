//
//  Outcome.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/14/22.
//

class Outcome: Codable {
    
    let winner: Int
    let loser: Int
    let tiedA: Int
    let tiedB: Int
    
    var winResults: (winner: Int, loser: Int)? {
        tiedA == -1 && tiedB == -1 ? (winner, loser) : nil
    }
    
    var tieResults: (teamA: Int, teamB: Int)? {
        winner == -1 && loser == -1 ? (tiedA, tiedB) : nil
    }
    
    init(winner: Int, loser: Int) {
        self.winner = winner
        self.loser = loser
        self.tiedA = -1
        self.tiedB = -1
    }
    
    init(tie: (teamA: Int, teamB: Int)) {
        self.winner = -1
        self.loser = -1
        self.tiedA = tie.teamA
        self.tiedB = tie.teamB
    }
    
}

class Outcomes: Codable {
    
    let value: [Outcome]
    
    init(value: [Outcome]) {
        self.value = value
    }
    
}
