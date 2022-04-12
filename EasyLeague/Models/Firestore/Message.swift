//
//  Message.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/12/22.
//

import MessageKit

class Message: Codable, MessageType {
    
    private let _sender: Sender
    private let _content: String
    
    let messageId: String
    let sentDate: Date
    
    var sender: SenderType { _sender }
    var kind: MessageKind { .text(_content) }
    
    var senderPhotoURL: String { _sender.photoURL }
    
    init(messageId: String, sender: Sender, content: String) {
        self.messageId = messageId
        self.sentDate = Date()
        _sender = sender
        _content = content
    }
    
}
