//
//  Outcome.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/14/22.
//

class Outcome: Codable {
    
    let winner: Int
    let loser: Int
    
    init(winner: Int, loser: Int) {
        self.winner = winner
        self.loser = loser
    }
    
}

class Outcomes: Codable {
    
    let value: [Outcome]
    
    init(value: [Outcome]) {
        self.value = value
    }
    
}
