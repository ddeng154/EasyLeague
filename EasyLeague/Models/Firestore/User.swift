//
//  User.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/4/22.
//

class User: Codable {
    
    let id: String
    var name: String
    var photoURL: String
    
    init(id: String, name: String, photoURL: String) {
        self.id = id
        self.name = name
        self.photoURL = photoURL
    }
    
}
