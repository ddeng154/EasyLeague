//
//  Sender.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/12/22.
//

import MessageKit

class Sender: Codable, SenderType {
    
    let senderId: String
    let displayName: String
    let photoURL: String
    
    init(user: User) {
        self.senderId = user.id
        self.displayName = user.name
        self.photoURL = user.photoURL
    }
    
}
