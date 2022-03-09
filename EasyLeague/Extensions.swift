//
//  Extensions.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/7/22.
//

import UIKit

extension UIViewController {
    func presentSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
