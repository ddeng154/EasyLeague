//
//  Team.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/31/22.
//

class Team: Codable {
    
    let index: Int
    var name: String
    var memberUserIDs: [String]
    
    init(index: Int) {
        self.index = index
        self.name = "Team \(index + 1)"
        self.memberUserIDs = []
    }
    
}
