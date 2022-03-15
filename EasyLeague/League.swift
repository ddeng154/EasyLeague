//
//  League.swift
//  EasyLeague
//
//  Created by Chen Zhou on 3/14/22.
//

import Foundation
import Firebase
import FirebaseDatabase

struct League {

    let name:String!
    let numTeams:Int!
    let numMatches:Int!
    let statistics:[String]!
    let tieBreaker:String!
    
    init(name:String, numTeams:Int, numMatches:Int, statistics:[String], tieBreaker:String) {
        self.name = name
        self.numTeams = numTeams
        self.numMatches = numMatches
        self.statistics = statistics
        self.tieBreaker = tieBreaker
    }
    
    init(snapshot:DataSnapshot) {
        
        self.name = snapshot.childSnapshot(forPath: "name").value as? String ?? ""
        self.numTeams = snapshot.childSnapshot(forPath: "numTeams").value as? Int ?? 0
        self.numMatches = snapshot.childSnapshot(forPath: "numMatches").value as? Int ?? 0
        self.statistics = snapshot.childSnapshot(forPath: "statistics").value as? [String] ?? [""]
        self.tieBreaker = snapshot.childSnapshot(forPath: "tieBreaker").value as? String ?? ""
    }
}

