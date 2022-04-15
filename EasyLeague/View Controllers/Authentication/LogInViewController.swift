//
//  LogInViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/3/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class LogInViewController: UIViewController {
    
    var authStateChanger: AuthStateChanger!
    
    lazy var titleLabel = createLabel(text: "EasyLeague") { label in
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 50, weight: .bold)
        label.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    lazy var emailField = createTextField(placeholder: "Email") { field in
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.keyboardType = .emailAddress
    }
    
    lazy var passwordField = createTextField(placeholder: "Password") { field in
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.isSecureTextEntry = true
    }
    
    lazy var logInButton = createButton(title: "Log In", action: #selector(logInButtonPressed))
    
    lazy var signUpButton = createButton(title: "Sign Up", action: #selector(signUpButtonPressed))
    
    lazy var spacer = createSpacer()
    
    lazy var stackView = createVerticalStack(spacing: 35)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .appBackground
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(logInButton)
        stackView.addArrangedSubview(signUpButton)
        stackView.addArrangedSubview(spacer)
        
        view.addSubview(stackView)
        
        constrainToSafeArea(stackView)
    }
    
    func presentLogInError(_ message: String) {
        presentSimpleAlert(title: "Log In Error", message: message)
    }
    
}

@objc extension LogInViewController {
    
    func logInButtonPressed() {
        guard emailField.hasText, let email = emailField.text else {
            return presentLogInError("Email field is empty")
        }
        guard passwordField.hasText, let password = passwordField.text else {
            return presentLogInError("Password field is empty")
        }
        let spinner = addSpinner()
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            spinner.remove()
            if let error = error {
                self.presentLogInError(error.localizedDescription)
            } else if let firebaseUser = authResult?.user {
                Firestore.firestore().documentForUser(firebaseUser.uid).getDocument(as: User.self) { result in
                    switch result {
                        case .success(let user):
                            self.authStateChanger.authenticated(user: user)
                        case .failure(let error):
                            self.presentLogInError(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func signUpButtonPressed() {
        let signUpController = SignUpViewController()
        signUpController.authStateChanger = authStateChanger
        show(signUpController, sender: self)
    }
    
}
