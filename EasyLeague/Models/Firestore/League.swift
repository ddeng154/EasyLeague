//
//  League.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/21/22.
//

struct League: Codable {
    
    let id: String
    let ownerUserID: String
    let memberUserIDs: [String]
    let name: String
    let numTeams: Int
    let numMatches: Int
    
}
