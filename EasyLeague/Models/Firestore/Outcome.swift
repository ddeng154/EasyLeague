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
    
    init(winner: Int, loser: Int, tiedA: Int, tiedB: Int) {
        self.winner = winner
        self.loser = loser
        self.tiedA = tiedA
        self.tiedB = tiedB
    }
    
}

class Outcomes: Codable {
    
    let value: [Outcome]
    
    init(value: [Outcome]) {
        self.value = value
    }
    
}
