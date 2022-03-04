//
//  Resources.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/3/22.
//

import UIKit

func SimpleAlertController(title: String, message: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    return alert
}
