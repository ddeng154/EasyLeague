//
//  RootViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/9/22.
//

import UIKit
import FirebaseAuth

protocol SignUpStateChanger {
    func signUpStarted()
    func signUpCompleted()
    func signUpError()
}

class RootViewController: UIViewController, SignUpStateChanger {
    
    var isLoggedIn = false
    var isWaitingForSignUp = false
    
    var currentViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Auth.auth().addStateDidChangeListener { _, user in
            self.isLoggedIn = user != nil
            self.updateCurrentViewController()
        }
    }
    
    func updateCurrentViewController() {
        guard !(isLoggedIn && isWaitingForSignUp) else { return }
        let nextViewController: UIViewController
        if isLoggedIn {
            nextViewController = UINavigationController(rootViewController: HomeViewController())
        } else {
            let logInController = LogInViewController()
            logInController.delegate = self
            nextViewController = logInController
        }
        currentViewController?.remove()
        add(nextViewController)
        currentViewController = nextViewController
    }
    
    func signUpStarted() {
        self.isWaitingForSignUp = true
    }
    
    func signUpCompleted() {
        self.isWaitingForSignUp = false
        updateCurrentViewController()
    }
    
    func signUpError() {
        self.isWaitingForSignUp = false
    }
    
}
