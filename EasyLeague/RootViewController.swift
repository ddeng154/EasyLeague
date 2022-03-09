//
//  RootViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/9/22.
//

import UIKit
import FirebaseAuth

class RootViewController: UIViewController {
    
    var currentViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Auth.auth().addStateDidChangeListener { _, user in
            if user != nil {
                self.currentViewController?.remove()
                let viewController = HomeViewController()
                self.add(viewController)
                self.currentViewController = viewController
            } else {
                self.currentViewController?.remove()
                let viewController = LogInViewController()
                self.add(viewController)
                self.currentViewController = viewController
            }
        }
    }
    
}
