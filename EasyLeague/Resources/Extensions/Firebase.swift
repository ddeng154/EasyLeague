//
//  Firebase.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/8/22.
//

import FirebaseFirestore
import FirebaseStorage

extension Firestore {
    
    var leagueCollection: CollectionReference {
        collection("leagues")
    }
    
    func leaguesQueryForUser(_ id: String) -> Query {
        leagueCollection.whereField("memberUserIDs", arrayContains: id)
    }
    
    var userCollection: CollectionReference {
        collection("users")
    }
    
    func documentForUser(_ id: String) -> DocumentReference {
        userCollection.document(id)
    }
    
    func chatsForLeague(_ id: String) -> CollectionReference {
        collection("chats/\(id)/thread")
    }
    
}

extension Storage {
    
    func photoReferenceForUser(_ id: String) -> StorageReference {
        reference().child("photos").child("\(id).png")
    }
    
}
