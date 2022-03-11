//
//  Extensions.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/7/22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

extension UIViewController {
    
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
    
}

extension User {
    
    var storageReferenceForPhoto: StorageReference {
        return Storage.storage().reference().child("images").child("\(uid).jpg")
    }
    
}
