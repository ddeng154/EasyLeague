//
//  SignUpViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 3/3/22.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "EasyLeague"
        return label
    }()
    
    var emailField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.placeholder = "Email"
        return field
    }()
    
    var passwordField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.placeholder = "Password"
        return field
    }()
    
    var signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        
        view.addConstraints([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            emailField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            emailField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            signUpButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            signUpButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    func presentSignUpError(_ message: String) {
        present(SimpleAlertController(title: "Sign Up Error", message: message), animated: true, completion: nil)
    }
    
    @objc func signUpButtonPressed() {
        guard emailField.hasText, let email = emailField.text else {
            return self.presentSignUpError("Email field is empty")
        }
        guard passwordField.hasText, let password = passwordField.text else {
            return self.presentSignUpError("Password field is empty")
        }
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                self.presentSignUpError(error.localizedDescription)
            }
        }
    }
    
}
