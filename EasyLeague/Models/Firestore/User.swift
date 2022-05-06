//
//  User.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/4/22.
//

import Foundation

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

extension User {
    
    func copy() throws -> User {
        let data = try JSONEncoder().encode(self)
        return try JSONDecoder().decode(Self.self, from: data)
    }
    
}
