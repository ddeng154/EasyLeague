//
//  Extensions.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/7/22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

extension UIViewController {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func presentSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func addSpinner() -> SpinnerViewController {
        let spinner = SpinnerViewController()
        add(spinner)
        return spinner
    }
    
    func withAutoLayout<V: UIView>(_ subview: V) -> V {
        subview.translatesAutoresizingMaskIntoConstraints = false
        return subview
    }
    
    func popFromNavigation() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension Firestore {
    
    var leagueCollection: CollectionReference {
        collection("leagues")
    }
    
    func documentsQueryForUser(_ id: String) -> Query {
        leagueCollection.whereField("memberUserIDs", arrayContains: id)
    }
    
}

extension User {
    
    var storageReferenceForPhoto: StorageReference {
        Storage.storage().reference().child("users").child(uid).child("photo.jpg")
    }
    
}

extension Int {
    
    init?(_ description: String?) {
        guard let description = description else { return nil }
        self.init(description)
    }
    
}
